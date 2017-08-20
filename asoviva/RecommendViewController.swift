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
import Chameleon
import GooglePlaces

class RecommendViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate{
    
    var userLocation: CLLocationCoordinate2D!
    var destLocation: CLLocationCoordinate2D!
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
        tableView.separatorColor = UIColor.clear
        return tableView
    }()
    
    var key = "AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSPlacesClient.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        GMSServices.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        
        let sortArray: [String] = ["","",""]
        
        let orange = UIColor(red:255/255, green: 165/255, blue: 0/255, alpha: 0.6)
        
        var Segcon: UISegmentedControl!
        Segcon = UISegmentedControl(items: sortArray as [AnyObject])
        let attribute = [NSForegroundColorAttributeName:UIColor.black]
        Segcon.setTitleTextAttributes(attribute, for: .normal)
        Segcon.frame = CGRect(x:0,y: 0 ,width: self.view.frame.width, height:30)
        Segcon.center = CGPoint(x: self.view.frame.width/2, y: 80)
        Segcon.backgroundColor = UIColor.white
        Segcon.tintColor = UIColor.clear
        Segcon.addTarget(self, action: #selector(sortchange(segcon:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(Segcon)
        
        segmentItemWidth = self.view.frame.width / 3
        underlineLayer.backgroundColor = orange.cgColor
        underlineLayer.frame = CGRect(x:15,y: 5, width:self.view.frame.width / 3 - 30,height: 20)
        underlineLayer.masksToBounds = true
        underlineLayer.cornerRadius = 5.0
        Segcon.layer.addSublayer(underlineLayer)
        
        let label1: UILabel = UILabel(frame: CGRect(x:0 , y: 0, width: 100, height: 20))
        label1.textColor = UIColor.black
        label1.text = "値段"
        label1.textAlignment = NSTextAlignment.center
        label1.layer.position = CGPoint(x:self.view.frame.width / 6,y: 15)
        Segcon.addSubview(label1)
        
        let label2: UILabel = UILabel(frame: CGRect(x:0 , y: 0, width: 100, height: 20))
        label2.textColor = UIColor.black
        label2.text = "評価"
        label2.textAlignment = NSTextAlignment.center
        label2.layer.position = CGPoint(x:self.view.frame.width / 2,y: 15)
        Segcon.addSubview(label2)
        
        let label3: UILabel = UILabel(frame: CGRect(x:0 , y: 0, width: 100, height: 20))
        label3.textColor = UIColor.black
        label3.text = "距離"
        label3.textAlignment = NSTextAlignment.center
        label3.layer.position = CGPoint(x:self.view.frame.width * 5 / 6,y: 15)
        Segcon.addSubview(label3)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
        
        cell.nameLabel.text = locations[indexPath.section].storename
        
        cell.photoButton.addTarget(self, action: #selector(photobutton), for: .touchUpInside)
        cell.phoneButton.addTarget(self, action: #selector(phonebutton), for: .touchUpInside)
        cell.priceButton.addTarget(self, action: #selector(pricebutton), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentbutton), for: .touchUpInside)
        cell.distanceButton.addTarget(self, action: #selector(distancebutton), for: .touchUpInside)
        cell.favoriteButton.addTarget(self, action: #selector(favoritebutton), for: .touchUpInside)
        cell.timeButton.addTarget(self, action: #selector(timebutton), for: .touchUpInside)
        
        cell.photoButton.tag = indexPath.section
        cell.phoneButton.tag = indexPath.section
        cell.priceButton.tag = indexPath.section
        cell.commentButton.tag = indexPath.section
        cell.distanceButton.tag = indexPath.section
        cell.favoriteButton.tag = indexPath.section
        cell.timeButton.tag = indexPath.section
        
        if locations[indexPath.section].storeimage == nil{
            
        }else{
            cell.storeimage1.image = locations[indexPath.section].storeimage
        }
        
        //cell.pointLabel.text = locations[indexPath.section]
        //cell.priceLabel.text = locations[indexPath.section]
        //cell.distantLabel.text= locations[indexPath.section]
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func pickfavorite(sender: UIButton) {
        
        print("sender:" + String(sender.tag))
        let storedata = favorite()
        storedata.storename = locations[sender.tag].storename
        storedata.lat = locations[sender.tag].lat
        storedata.lng = locations[sender.tag].lng
        storedata.vicinity = locations[sender.tag].vicinity
        storedata.placeid = locations[sender.tag].placeId
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
    
    func firstButton(){
        print("first")
    }
    
    
    
    
    func sortchange(segcon: UISegmentedControl){
        
        underlineLayer.frame.origin.x = CGFloat(segcon.selectedSegmentIndex) * segmentItemWidth + 15
        
        switch segcon.selectedSegmentIndex {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            print("default")
        }
        
    }
    func pricebutton(sender: UIButton){
        print("price")
        
    }
    
    func phonebutton(sender: UIButton){
        print("phone")
    }
    
    func commentbutton(sender: UIButton) {
        print("comment")
        
        let commentview = commentViewController()
        self.navigationController?.pushViewController(commentview, animated: true)
    }
    
    func distancebutton(sender: UIButton){
        print("distance")
        UserDafault.set(nowlat, forKey: "nowlat")
        UserDafault.set(nowlng, forKey: "nowlng")
        UserDafault.set(locations[sender.tag].lat, forKey: "goallat")
        UserDafault.set(locations[sender.tag].lng, forKey: "goallng")
        let routeview = RouteViewController()
        self.navigationController?.pushViewController( routeview, animated: true)
    }
    func favoritebutton(sender: UIButton) {
        print("favorite")
        
        print("sender:" + String(sender.tag))
        let storedata = favorite()
        storedata.storename = locations[sender.tag].storename
        storedata.lat = locations[sender.tag].lat
        storedata.lng = locations[sender.tag].lng
        storedata.vicinity = locations[sender.tag].vicinity
        storedata.placeid = locations[sender.tag].placeId
        storedata.id = favorite.lastId()
        try! realm.write {
            realm.add(storedata)
            
        }
        
        SCLAlertView().showInfo("お気に入り登録完了", subTitle: locations[sender.tag].storename + "をお気に入り登録しました。")
        
    }
    
    func photobutton(sender: UIButton) {
        print("photo")
    }
    func timebutton(sender: UIButton) {
        print("time")
    }
    func loadFirstPhotoForPlace(placeID: String,IndexPath:IndexPath) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto,IndexPath:IndexPath)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata,IndexPath:IndexPath) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                // self.imageView.image = photo
                // self.attributionTextView.attributedText = photoMetadata.attributions
                self.locations[IndexPath.section].storeimage = photo
                self.storeTableView.reloadData()
            }
        })
    }
}

