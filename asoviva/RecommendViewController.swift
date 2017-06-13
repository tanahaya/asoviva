//
//  RecommendViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/15.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import ObjectMapper
import SwiftyJSON
import FontAwesome
import RealmSwift
import Social

class RecommendViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate{
    
    var userLocation: CLLocationCoordinate2D!
    var destLocation : CLLocationCoordinate2D!
    var Region: MKCoordinateRegion!
    var nowlat: CLLocationDegrees!
    var nowlng: CLLocationDegrees!
    var UserDafault:UserDefaults = UserDefaults()
    
    let placeID = "ChIJV4k8_9UodTERU5KXbkYpSYs"
    let realm = try! Realm()
    
    let underlineLayer = CALayer()
    var segmentItemWidth:CGFloat = 0
    
    let detailcolor = UIColor(red: 0, green: 108, blue: 241, alpha: 1.0)
    let guidecolor = UIColor(red: 243 , green: 152, blue: 29, alpha: 1.0)
    
    var locations:[Location] = []
    
    lazy var mapView: MKMapView = {
        
        let mapView: MKMapView = MKMapView()
        mapView.delegate = self
        let mapframe: CGRect = CGRect(x: 0, y: 95, width: self.view.frame.width, height: self.view.frame.height / 2 - 95 )
        //let mapframe: CGRect = CGRect(x: 0, y: 60 , width: self.view.frame.width, height: self.view.frame.height / 2 + 15)
        mapView.frame = mapframe
        let nowlat: Double = 35.680298
        let nowlng: Double = 139.766247
        let myLatitude: CLLocationDegrees = nowlat
        let myLongitude: CLLocationDegrees = nowlng
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        mapView.setCenter(center, animated: true)
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegionMake(center, mySpan)
        mapView.region = region
        return mapView
    }()
    
    lazy var locationManager:CLLocationManager = {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 300
        return locationManager
    }()
    
    lazy var storeTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height / 2 - 15,  width: self.view.frame.width, height: self.view.frame.height / 2 - 35 ))
        //let tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height / 2 - 45 ,  width: self.view.frame.width, height: 330))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "storeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "storeTableViewCell")
        let detailnib = UINib(nibName: "storedetailTableViewCell", bundle: nil)
        tableView.register(detailnib, forCellReuseIdentifier: "storedetailTableViewCell")
        return tableView
    }()
    
    var key = "AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortArray: [String] = ["値段","評価","距離"]
        
        var Segcon: UISegmentedControl!
        Segcon = UISegmentedControl(items: sortArray as [AnyObject])
        let attribute = [NSForegroundColorAttributeName:UIColor.white]
        Segcon.setTitleTextAttributes(attribute, for: .normal)
        Segcon.frame = CGRect(x:0,y: 0 ,width: self.view.frame.width, height:30)
        Segcon.center = CGPoint(x: self.view.frame.width/2, y: 80)
        Segcon.backgroundColor = UIColor.orange
        Segcon.tintColor = UIColor.clear
        Segcon.addTarget(self, action: #selector(sortchange(segcon:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(Segcon)
        
        segmentItemWidth = self.view.frame.width / 3
        underlineLayer.backgroundColor = UIColor.yellow.cgColor
        underlineLayer.frame = CGRect(x:0,y: 27.5, width:self.view.frame.width / 3,height: 2.5)
        Segcon.layer.addSublayer(underlineLayer)
        
        self.view.backgroundColor = UIColor.white
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.startUpdatingLocation()
        }
        //nowlat = locationManager.location!.coordinate.latitude
        nowlat  = 35.680298
        // nowlng = locationManager.location!.coordinate.longitude
        nowlng = 139.766247
        self.view.addSubview(mapView)
        self.view.addSubview(storeTableView)
        self.searchrecommendPlace()
        self.navigationItem.title  = "Asoviva"
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    func searchrecommendPlace(){
        let searchword : [String] = ["カラオケ"]
        locations = []
        let semaphore = DispatchSemaphore(value: 0)
        for i in 0 ..< searchword.count {
            let encodeStr = searchword[i].addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(nowlat!),\(nowlng!)&radius=2000&sensor=true&key=\(key)&name=\(encodeStr!)&lang=ja"
            let testURL:URL = URL(string: url)!
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: testURL, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    print("\(String(describing: error))")
                } else {
                    if let statusCode = response as? HTTPURLResponse {
                        if statusCode.statusCode != 200 {
                            print("\(String(describing: response))")
                        }
                    }
                    guard let data:Data = data else {return}
                    let json = JSON(data)
                    json["results"].array?.forEach({
                        var location:Location = Mapper<Location>().map(JSON: $0.dictionaryObject!)!
                        location.lat = $0["geometry"]["location"]["lat"].doubleValue
                        location.lng = $0["geometry"]["location"]["lng"].doubleValue
                        let Pin: MKPointAnnotation = MKPointAnnotation()
                        Pin.coordinate = CLLocationCoordinate2DMake(location.lat,location.lng)
                        Pin.title = location.storename
                        self.mapView.addAnnotation(Pin)
                        location.annotation = Pin
                        self.locations.append(location)
                        
                    })
                }
                sleep(UInt32(0.1))
                semaphore.signal()
            }).resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        storeTableView.reloadData()
        
    }
    
    func showUserAndDestinationOnMap() {
        let maxLat:Double = fmax(userLocation.latitude,  destLocation.latitude)
        let maxLon:Double = fmax(userLocation.longitude, destLocation.longitude)
        let minLat:Double = fmin(userLocation.latitude,  destLocation.latitude)
        let minLon:Double = fmin(userLocation.longitude, destLocation.longitude)
        
        let mapMargin:Double = 1.5;  // 経路が入る幅(1.0)＋余白(0.5)
        let leastCoordSpan:Double = 0.005;    // 拡大表示したときの最大値
        let span_x:Double = fmax(leastCoordSpan, fabs(maxLat - minLat) * mapMargin)
        let span_y:Double = fmax(leastCoordSpan, fabs(maxLon - minLon) * mapMargin)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(span_x, span_y)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLat + minLat) / 2, (maxLon + minLon) / 2)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        mapView.setRegion(mapView.regionThatFits(region), animated:true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.red
        return routeRenderer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowInSection = locations[section].extended ? 2 : 1
        return rowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
            
            cell.nameLabel.text = locations[indexPath.section].storename
            //cell.pointLabel.text = locations[indexPath.section]
            //cell.priceLabel.text = locations[indexPath.section]
            //cell.distantLabel.text= locations[indexPath.section]
            cell.pointLabel.textAlignment = NSTextAlignment.left
            cell.priceLabel.textAlignment = NSTextAlignment.left
            cell.distantLabel.textAlignment = NSTextAlignment.left
            cell.numberLabel.text = "# " + String(indexPath.section + 1)
            
            return cell
            
        }else{
            
            let cell:storedetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storedetailTableViewCell", for: indexPath as IndexPath) as! storedetailTableViewCell
            
            cell.nameLabel.text = locations[indexPath.section].storename
            cell.favoritebutton.addTarget(self, action: #selector(pickfavorite), for: .touchUpInside)
            cell.favoritebutton.tag = indexPath.section
            cell.webbutton.addTarget(self, action: #selector(moveweb), for: .touchUpInside)
            cell.sharebutton.addTarget(self, action: #selector(share), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else {
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if 0 == indexPath.row {
            // switching open or close
            
            locations[indexPath.section].extended = !locations[indexPath.section].extended
            if !locations[indexPath.section].extended {
                self.toContract(tableView, indexPath: indexPath)
            }else{
                self.toExpand(tableView, indexPath: indexPath)
            }
            
        }else{ // ADD:
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func toContract(_ tableView: UITableView, indexPath: IndexPath) {
        
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(row: 1 , section:indexPath.section))
        
        tableView.deleteRows(at: indexPaths,
                             with: UITableViewRowAnimation.fade)
    }
    
    fileprivate func toExpand(_ tableView: UITableView, indexPath: IndexPath) {
        
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(row: 1, section:indexPath.section))
        
        tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        
        tableView.scrollToRow(at: IndexPath(
            row:indexPath.row, section:indexPath.section),at: UITableViewScrollPosition.top, animated: true)
    }
    
    func pickfavorite(sender: UIButton) {
        print("sender:" + String(sender.tag))
        let storedata = favorite()
        storedata.storename = locations[sender.tag].storename
        storedata.lat = locations[sender.tag].lat
        storedata.lng = locations[sender.tag].lng
        storedata.vicinity = locations[sender.tag].vicinity
        storedata.placeid = locations[sender.tag].placeid
        storedata.id = favorite.lastId()
        try! realm.write {
            realm.add(storedata)
            
        }
        
        SCLAlertView().showInfo("お気に入り登録完了", subTitle: locations[sender.tag].storename + "をお気に入り登録しました。")
    }
    func moveweb(sender: UIButton) {
        
        let webviewController = WebPageViewController()
        // webviewController.url = locations[sender.tag]
        
        self.navigationController?.pushViewController(webviewController, animated: true)
    }
    func share(sender: UIButton){
        
        let alertView = SCLAlertView()
        alertView.addButton("facebookでシェア", target:self, selector:#selector(sharetwitter))
        alertView.addButton("Twitterでシェア") {
            print("Second button tapped")
            self.sharefacebook()
        }
        alertView.showSuccess("Button View", subTitle: "This alert view has buttons")
        
        //SCLAlertView().showInfo("お気に入り登録完了", subTitle: locations[sender.tag].storename + "をお気に入り登録しました。")
    }
    func firstButton(){
        print("first")
    }
    func sharetwitter() {
        
        let text = "twitter share text"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(text)
        
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    func sharefacebook() {
        
        let text = "facebook share text"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(text)
        
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    func sortchange(segcon: UISegmentedControl){
        
        underlineLayer.frame.origin.x = CGFloat(segcon.selectedSegmentIndex) * segmentItemWidth
        
        switch segcon.selectedSegmentIndex {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            print("Error")
        }
        
    }
    
}

