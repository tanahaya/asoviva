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
import ObjectMapper
import SwiftyJSON
import FontAwesome
import RealmSwift
import Chameleon
import Alamofire

class RecommendViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate{
    
    var Region: MKCoordinateRegion!
    var nowlat: CLLocationDegrees!
    var nowlng: CLLocationDegrees!
    var UserDafault:UserDefaults = UserDefaults()
    
    let placeID = "ChIJV4k8_9UodTERU5KXbkYpSYs"
    let config = Realm.Configuration(schemaVersion: 1)
    
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
    
    var key = "AIzaSyDJlAPj1HOf0UirK-NomfpAlwY6U71soaNY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //self.searchrecommendPlace()
        self.searchplaceRubyonRails()
        self.navigationItem.title  = "Asoviva"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchplaceRubyonRails()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
        
        cell.nameLabel.text = locations[indexPath.row].storename
        cell.priceLabel.text = " \(locations[indexPath.row].price!)" + "円"
        cell.favoriteLabel.text = "\( Double(locations[indexPath.row].recommendnumber) / 10.0 )" + "点"
        
        if indexPath.row == 0{
            cell.commentLabel.text = "4つ"
            cell.photoLabel.text = "4枚"
        }else if indexPath.row % 3 == 0 {
            cell.photoLabel.text = "4枚"
            cell.commentLabel.text = "1つ"
        }else{
            cell.photoLabel.text = "0枚"
            cell.commentLabel.text = "\(locations[indexPath.row].commentnumber!)" + "つ"
        }
        
        self.gettimeroute()
        if indexPath.row == 0{
            cell.distanceLabel.text = "8分"
        }else {
            cell.distanceLabel.text = "\(arc4random_uniform(10) + 7 )" + "分"
        }
        if locations[indexPath.row].storename.characters.count > 24 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 10)
        }else if locations[indexPath.row].storename.characters.count > 19 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 12)
        }else if locations[indexPath.row].storename.characters.count > 14 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
        }else  {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        cell.photoButton.addTarget(self, action: #selector(photobutton), for: .touchUpInside)
        cell.phoneButton.addTarget(self, action: #selector(phonebutton), for: .touchUpInside)
        cell.priceButton.addTarget(self, action: #selector(pricebutton), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentbutton), for: .touchUpInside)
        cell.distanceButton.addTarget(self, action: #selector(distancebutton), for: .touchUpInside)
        cell.favoriteButton.addTarget(self, action: #selector(favoritebutton), for: .touchUpInside)
        cell.timeButton.addTarget(self, action: #selector(timebutton), for: .touchUpInside)
        
        cell.photoButton.tag = indexPath.row
        cell.phoneButton.tag = indexPath.row
        cell.priceButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        cell.distanceButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        cell.timeButton.tag = indexPath.row
        
        
        if locations[indexPath.row].photos == nil {
            
        }else{
            
            let dataDecoded1 : Data = Data(base64Encoded: (locations[indexPath.row].photos?[0])!, options: .ignoreUnknownCharacters)!
            let decodedimage1 = UIImage(data: dataDecoded1)
            cell.storeimage1.image = decodedimage1
            
            let dataDecoded2 : Data = Data(base64Encoded: (locations[indexPath.row].photos?[1])!, options: .ignoreUnknownCharacters)!
            let decodedimage2 = UIImage(data: dataDecoded2)
            cell.storeimage2.image = decodedimage2
            
            let dataDecoded3 : Data = Data(base64Encoded: (locations[indexPath.row].photos?[2])!, options: .ignoreUnknownCharacters)!
            let decodedimage3 = UIImage(data: dataDecoded3)
            cell.storeimage3.image = decodedimage3
            
            let dataDecoded4 : Data = Data(base64Encoded: (locations[indexPath.row].photos?[3])!, options: .ignoreUnknownCharacters)!
            let decodedimage4 = UIImage(data: dataDecoded4)
            cell.storeimage4.image = decodedimage4
            
            UserDafault.set( (locations[indexPath.row].photos?[0])!, forKey: "photo0")
            UserDafault.set( (locations[indexPath.row].photos?[1])!, forKey: "photo1")
            UserDafault.set( (locations[indexPath.row].photos?[2])!, forKey: "photo2")
            UserDafault.set( (locations[indexPath.row].photos?[3])!, forKey: "photo3")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        let url = NSURL(string: "tel://09012345678")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
        print("phone")
    }
    
    func commentbutton(sender: UIButton) {
        print("comment")
        
        UserDafault.set(locations[sender.tag].placeId, forKey: "place_id")
        UserDafault.set(locations[sender.tag].storename, forKey: "place_name")
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
        storedata.recommendnumber = locations[sender.tag].recommendnumber
        storedata.commentnumber = locations[sender.tag].commentnumber
        storedata.price = locations[sender.tag].price
        storedata.photo1 = locations[sender.tag].photos?[0]
        storedata.photo2 = locations[sender.tag].photos?[1]
        storedata.photo3 = locations[sender.tag].photos?[2]
        storedata.photo4 = locations[sender.tag].photos?[3]
        storedata.id = favorite.lastId()
        
        try! realm.write {
            realm.add(storedata)
        }
        
        SCLAlertView().showInfo("お気に入り登録完了", subTitle: "")
        
    }
    
    func photobutton(sender: UIButton) {
        print("photo")
        
        UserDafault.set(locations[sender.tag].placeId, forKey: "place_id")
        let showImage = showImageViewController()
        self.navigationController?.pushViewController(showImage, animated: true)
        
    }
    func timebutton(sender: UIButton) {
        print("time")
    }
    
    func searchplaceRubyonRails(){
        
        let params:[String: Any] = ["lat": 35.680298,"lng": 139.766247]
        
        Alamofire.request("https://server-tanahaya.c9users.io/api/searchplace", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            let res = JSON(response.result.value!)
            var locations: [Location] = []
            res["results"].array?.forEach({
                var location:Location = Mapper<Location>().map(JSON: $0.dictionaryObject!)!
                location.lat = $0["geometry"]["location"]["lat"].doubleValue
                location.lng = $0["geometry"]["location"]["lng"].doubleValue
                let Pin: MKPointAnnotation = MKPointAnnotation()
                Pin.coordinate = CLLocationCoordinate2DMake(location.lat,location.lng)
                Pin.title = location.storename
                self.mapView.addAnnotation(Pin)
                location.annotation = Pin
                locations.append(location)
            })
            self.locations = locations
            //print(self.locations)
            self.storeTableView.reloadData()
        }
    }
    
    func gettimeroute(){
        
    }
    
}
