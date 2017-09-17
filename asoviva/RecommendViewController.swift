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
    
    var locations:[Location] = []
    
    var params:[String: Any] = [:]
    
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
        label3.text = "アクセス"
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
        self.searchplaceRubyonRails()
        self.navigationItem.title  = "Asoviva"
        /*
         let rightButton = UIBarButtonItem(title: "Line", style: UIBarButtonItemStyle.plain, target: self, action: #selector ( sendMessage))
         self.navigationItem.rightBarButtonItem = rightButton
         */
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
        
        if locations[indexPath.row].price == nil {
            cell.priceLabel.text = "--円"
        }else{
            cell.priceLabel.text = "\(locations[indexPath.row].price!)円"
        }
        if locations[indexPath.row].recommendnumber == nil {
            cell.favoriteLabel.text = "--点"
        }else {
            cell.favoriteLabel.text = "\( Double(locations[indexPath.row].recommendnumber!) / 10.0 )点"
        }
        
        cell.commentLabel.text = "\( locations[indexPath.row].commentnumber! )個"
        cell.photoLabel.text = "\( locations[indexPath.row].photonubmer! )枚"
        
        if locations[indexPath.row].opennow{
            let clockImage = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.white, size: CGSize(width:25,height:25))
            cell.timeimage.image = clockImage
            
        }else{
            let clockImage = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.flatNavyBlueColorDark(), size: CGSize(width:25,height:25))
            cell.timeimage.image = clockImage
        }
        
        //以下時間を割り出す方法
        let requestCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations[indexPath.row].lat, locations[indexPath.row].lng)
        let fromCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake( nowlat, nowlng)
        
        let fromPlace: MKPlacemark = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
        let toPlace: MKPlacemark = MKPlacemark(coordinate: requestCoordinate, addressDictionary: nil)
        
        let fromItem: MKMapItem = MKMapItem(placemark: fromPlace)
        let toItem: MKMapItem = MKMapItem(placemark: toPlace)
        
        let myRequest: MKDirectionsRequest = MKDirectionsRequest()
        
        myRequest.source = fromItem
        myRequest.destination = toItem
        myRequest.requestsAlternateRoutes = true
        myRequest.transportType = MKDirectionsTransportType.automobile
        
        let myDirections: MKDirections = MKDirections(request: myRequest)
        
        myDirections.calculate { (response, error) in
            if error != nil || response!.routes.isEmpty {
                return
            }
            let route: MKRoute = response!.routes[0] as MKRoute
            cell.distanceLabel.text = ("\(Int(route.expectedTravelTime/60))分")
        }
        
        if locations[indexPath.row].storename.characters.count > 24 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 10)
        }else if locations[indexPath.row].storename.characters.count > 19 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 12)
        }else if locations[indexPath.row].storename.characters.count > 14 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
        }else{
            cell.nameLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        cell.photoButton.addTarget(self, action: #selector(photobutton), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(sharebutton), for: .touchUpInside)
        cell.priceButton.addTarget(self, action: #selector(pricebutton), for: .touchUpInside)
        cell.commentButton.addTarget(self, action: #selector(commentbutton), for: .touchUpInside)
        cell.distanceButton.addTarget(self, action: #selector(distancebutton), for: .touchUpInside)
        cell.favoriteButton.addTarget(self, action: #selector(favoritebutton), for: .touchUpInside)
        cell.timeButton.addTarget(self, action: #selector(timebutton), for: .touchUpInside)
        
        cell.photoButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.priceButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        cell.distanceButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        cell.timeButton.tag = indexPath.row
        
        if locations[indexPath.row].photos == nil {
            cell.storeimage1.image = UIImage(named: "nophoto.png")
            cell.storeimage2.image = UIImage(named: "nophoto.png")
            cell.storeimage3.image = UIImage(named: "nophoto.png")
            cell.storeimage4.image = UIImage(named: "nophoto.png")
        }else {
            
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
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func sortchange(segcon: UISegmentedControl){
        
        underlineLayer.frame.origin.x = CGFloat(segcon.selectedSegmentIndex) * segmentItemWidth + 15
        
        switch segcon.selectedSegmentIndex {
        case 0:
            print("0")
            self.params["sort"] = "price"
        case 1:
            print("1")
            self.params["sort"] = "recommend"
        case 2:
            print("2")
            self.params["sort"] = "time"
        default:
            print("default")
            self.params["sort"] = "price"
        }
        
    }
    
    func pricebutton(sender: UIButton){
        print("price")
        
    }
    
    func sharebutton(sender: UIButton){
        let alertSheet = UIAlertController(title: "Share", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let lineSchemeMessage: String! = "line://msg/text/"
        var scheme: String! = lineSchemeMessage + "asoviva://" + self.locations[sender.tag].placeId
        
        let action1 = UIAlertAction(title: "Lineでシェア", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("Lineでシェア")
            
            scheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let messageURL: URL! = URL(string: scheme)
            
            self.openURL(messageURL)
            
        })
        let action2 = UIAlertAction(title: "クリップボードにコピー", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("クリップボードにコピー")
            let board = UIPasteboard.general
            board.setValue( scheme, forPasteboardType: "public.text")
        })
        let action3 = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("cancel")
        })
        
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    func commentbutton(sender: UIButton) {
        print("comment")
        let alert = SCLAlertView()
        alert.addButton("コメントを投稿する", action: {
            self.UserDafault.set(self.locations[sender.tag].placeId, forKey: "place_id")
            self.UserDafault.set(self.locations[sender.tag].storename, forKey: "place_name")
            let commentview = commentViewController()
            self.navigationController?.pushViewController(commentview, animated: true)
        })
        alert.showSuccess("コメントがまだありません", subTitle: "コメントを書きますか?")
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
        
        let alert = SCLAlertView()
        alert.addButton("お気に入り登録", action: {
            let storedata = favorite()
            storedata.storename = self.locations[sender.tag].storename
            storedata.lat = self.locations[sender.tag].lat
            storedata.lng = self.locations[sender.tag].lng
            storedata.vicinity = self.locations[sender.tag].vicinity
            storedata.placeid = self.locations[sender.tag].placeId
            storedata.recommendnumber = self.locations[sender.tag].recommendnumber
            storedata.commentnumber = self.locations[sender.tag].commentnumber
            storedata.price = self.locations[sender.tag].price
            storedata.photo1 = self.locations[sender.tag].photos?[0]
            storedata.photo2 = self.locations[sender.tag].photos?[1]
            storedata.photo3 = self.locations[sender.tag].photos?[2]
            storedata.photo4 = self.locations[sender.tag].photos?[3]
            storedata.id = favorite.lastId()
            
            try! self.realm.write {
                self.realm.add(storedata)
            }
        })
        alert.showSuccess("お気に入り登録しますか？", subTitle: "")
        
    }
    
    func photobutton(sender: UIButton) {
        print("photo")
        
        UserDafault.set(locations[sender.tag].placeId, forKey: "place_id")
        let showImage = showImageViewController()
        self.navigationController?.pushViewController(showImage, animated: true)
        
    }
    func timebutton(sender: UIButton) {
        print("time")
        if locations[sender.tag].opennow{
            SCLAlertView().showInfo("現在、開店中です。", subTitle: "")
        }else {
            SCLAlertView().showInfo("現在、閉店中です。", subTitle: "")
        }
    }
    
    func searchplaceRubyonRails(){
        
        self.params["lat"] = 35.680298
        self.params["lng"] = 139.766247
        Alamofire.request("https://server-tanahaya.c9users.io/api/searchplace", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            let res = JSON(response.result.value!)
            var locations: [Location] = []
            res["results"].array?.forEach({
                var location:Location = Mapper<Location>().map(JSON: $0.dictionaryObject!)!
                location.lat = $0["geometry"]["location"]["lat"].doubleValue
                location.lng = $0["geometry"]["location"]["lng"].doubleValue
                location.opennow = $0["opening_hours"]["open_now"].boolValue
                let Pin: MKPointAnnotation = MKPointAnnotation()
                Pin.coordinate = CLLocationCoordinate2DMake(location.lat,location.lng)
                Pin.title = location.storename
                self.mapView.addAnnotation(Pin)
                location.annotation = Pin
                locations.append(location)
            })
            self.locations = locations
            self.storeTableView.reloadData()
        }
    }
    
    
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // 本来であれば、指定したURLで開けないときの実装を別途行う必要がある
            print("failed to open..")
        }
    }
    
}
