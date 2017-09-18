//
//  sharedViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/09/15.
//  Copyright © 2017年 田中 颯. All rights reserved.
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

class sharedViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
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
        let mapframe: CGRect = CGRect(x: 0, y: 65, width: self.view.frame.width, height: self.view.frame.height / 2 + 30)
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
        
        let tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height / 2 + 95,  width: self.view.frame.width, height: self.view.frame.height / 2 - 100 ))
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
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(mapView)
        self.view.addSubview(storeTableView)
        self.navigationItem.title  = "Asoviva"
        
        let leftButton = UIBarButtonItem(title: "おすすめへ", style: UIBarButtonItemStyle.plain, target: self, action: #selector ( gorecommend))
        self.navigationItem.leftBarButtonItem = leftButton
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchplaceRubyonRails()
        locationManager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        nowlat = newLocation.coordinate.latitude
        nowlng = newLocation.coordinate.longitude
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
        
        cell.nameLabel.text = locations[0].storename
        
        if locations[0].price == 0 {
            cell.priceLabel.text = "--円"
        }else{
            cell.priceLabel.text = "\(locations[0].price!)円"
        }
        
        if locations[0].recommendnumber == 0 {
            cell.favoriteLabel.text = "--点"
        }else {
            cell.favoriteLabel.text = "\( Double(locations[0].recommendnumber!) / 10.0 )点"
        }
        
        if locations[0].commentnumber == 0 {
            cell.commentLabel.text = "0個"
        }else {
            cell.commentLabel.text = "\( locations[0].commentnumber! )個"
        }
        
        if locations[0].photonumber == nil {
            cell.photoLabel.text = "0枚"
        }else {
            cell.photoLabel.text = "\( locations[0].photonumber! )枚"
        }
        
        if locations[indexPath.row].opennow{
            let clockImage = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.white, size: CGSize(width:25,height:25))
            cell.timeimage.image = clockImage
            
        }else{
            let clockImage = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.flatNavyBlueColorDark(), size: CGSize(width:25,height:25))
            cell.timeimage.image = clockImage
        }
        
        cell.distanceLabel.text = "\(locations[0].time!)" + "分"
        
        if locations[0].storename.characters.count > 24 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 10)
        }else if locations[0].storename.characters.count > 19 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 12)
        }else if locations[0].storename.characters.count > 14 {
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
        
        cell.photoButton.tag = 0
        cell.shareButton.tag = 0
        cell.priceButton.tag = 0
        cell.commentButton.tag = 0
        cell.distanceButton.tag = 0
        cell.favoriteButton.tag = 0
        cell.timeButton.tag = 0
        
        if locations[0].photos == nil {
            cell.storeimage1.image = UIImage(named: "nophoto.png")
            cell.storeimage2.image = UIImage(named: "nophoto.png")
            cell.storeimage3.image = UIImage(named: "nophoto.png")
            cell.storeimage4.image = UIImage(named: "nophoto.png")
        }else {
            
            let dataDecoded1 : Data = Data(base64Encoded: (locations[0].photos?[0])!, options: .ignoreUnknownCharacters)!
            let decodedimage1 = UIImage(data: dataDecoded1)
            cell.storeimage1.image = decodedimage1
            
            let dataDecoded2 : Data = Data(base64Encoded: (locations[0].photos?[1])!, options: .ignoreUnknownCharacters)!
            let decodedimage2 = UIImage(data: dataDecoded2)
            cell.storeimage2.image = decodedimage2
            
            let dataDecoded3 : Data = Data(base64Encoded: (locations[0].photos?[2])!, options: .ignoreUnknownCharacters)!
            let decodedimage3 = UIImage(data: dataDecoded3)
            cell.storeimage3.image = decodedimage3
            
            let dataDecoded4 : Data = Data(base64Encoded: (locations[0].photos?[3])!, options: .ignoreUnknownCharacters)!
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
    
    
    func pricebutton(sender: UIButton){
        print("price")
        
    }
    
    func sharebutton(sender: UIButton){
        let alertSheet = UIAlertController(title: "Share", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let lineSchemeMessage: String! = "line://msg/text/"
        var scheme: String! =  self.locations[sender.tag].storename + "\n" + "asoviva://" + self.locations[sender.tag].placeId
        
        let action1 = UIAlertAction(title: "Lineでシェア", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            scheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let messageURL: URL! = URL(string: lineSchemeMessage + scheme)
            
            self.openURL(messageURL)
            
        })
        let action2 = UIAlertAction(title: "クリップボードにコピー", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            let board = UIPasteboard.general
            board.setValue(scheme, forPasteboardType: "public.text")
            
        })
        let action3 = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    func commentbutton(sender: UIButton) {
        print("comment")
        let alert = SCLAlertView()
        alert.labelTitle.font =  UIFont.systemFont(ofSize: 15)
        if locations[sender.tag].commentnumber == 0{
            alert.addButton("コメントを投稿する", action: {
                self.UserDafault.set(self.locations[sender.tag].placeId, forKey: "place_id")
                self.UserDafault.set(self.locations[sender.tag].storename, forKey: "place_name")
                let postcommentview = postcommentFormViewController()
                self.navigationController?.pushViewController(postcommentview, animated: true)
            })
            alert.showNotice("コメントがまだありません", subTitle: "コメントを書きますか?")
        }else{
            self.UserDafault.set(self.locations[sender.tag].placeId, forKey: "place_id")
            self.UserDafault.set(self.locations[sender.tag].storename, forKey: "place_name")
            let commentview = commentViewController()
            self.navigationController?.pushViewController(commentview, animated: true)
        }
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
        alert.labelTitle.font =  UIFont.systemFont(ofSize: 15)
        alert.addButton("お気に入り登録", action: {
            let storedata = favorite()
            storedata.storename = self.locations[sender.tag].storename
            storedata.lat = self.locations[sender.tag].lat
            storedata.lng = self.locations[sender.tag].lng
            storedata.vicinity = self.locations[sender.tag].vicinity
            storedata.placeid = self.locations[sender.tag].placeId
            storedata.photonumber = self.locations[sender.tag].photonumber
            if self.locations[sender.tag].recommendnumber == nil{
                storedata.recommendnumber = 30
            }else{
                storedata.recommendnumber = self.locations[sender.tag].recommendnumber
            }
            if self.locations[sender.tag].commentnumber == nil {
                storedata.commentnumber = 0
            }else{
                storedata.commentnumber = self.locations[sender.tag].commentnumber
            }
            if self.locations[sender.tag].price == nil{
                storedata.price = 1000
            }else{
                storedata.price = self.locations[sender.tag].price
            }
            
            storedata.photo1 = self.locations[sender.tag].photos?[0]
            storedata.photo2 = self.locations[sender.tag].photos?[1]
            storedata.photo3 = self.locations[sender.tag].photos?[2]
            storedata.photo4 = self.locations[sender.tag].photos?[3]
            storedata.id = favorite.lastId()
            
            try! self.realm.write {
                self.realm.add(storedata)
            }
        })
        alert.showSuccess("お気に入り登録しますか？", subTitle: "お気に入りは\nいつでも見ることが出来ます")
    }
    
    func photobutton(sender: UIButton) {
        print("photo")
        if locations[sender.tag].photonumber == 0{
            let alert = SCLAlertView()
            alert.labelTitle.font =  UIFont.systemFont(ofSize: 15)
            alert.showSuccess("写真がありません", subTitle: "")
        }else{
            
            UserDafault.set(locations[sender.tag].placeId, forKey: "place_id")
            let showImage = showImageViewController()
            self.navigationController?.pushViewController(showImage, animated: true)
        }
        
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
        self.locations = []
        var params:[String: Any] = [:]
        params["place_id"] = "ChIJhUl5xbOOGGARm0_QXUoAMIE"//UserDafault.string(forKey: "sharedplaceid")
        //print(params)
        Alamofire.request("https://server-tanahaya.c9users.io/api/searchplace/shared", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            let res = JSON(response.result.value!)
            
            var location:Location = Mapper<Location>().map(JSON: res["result"].dictionaryObject!)!
            location.lat = res["result"]["geometry"]["location"]["lat"].doubleValue
            location.lng = res["result"]["geometry"]["location"]["lng"].doubleValue
            location.opennow = res["result"]["opening_hours"]["open_now"].boolValue
            let Pin: MKPointAnnotation = MKPointAnnotation()
            Pin.coordinate = CLLocationCoordinate2DMake(location.lat,location.lng)
            Pin.title = location.storename
            self.mapView.addAnnotation(Pin)
            location.annotation = Pin
            let now: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.lat, location.lng)
            self.mapView.setCenter(now, animated: true)
            self.locations.append(location)
            self.storeTableView.reloadData()
        }
    }
    
    func gorecommend(){
        let Recommend = RecommendViewController()
        self.navigationController?.pushViewController( Recommend, animated: true)
    }
    
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // 本来であれば、指定したURLで開けないときの実装を別途行う必要がある
            print("failed to open..")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let testPinView = MKAnnotationView()
        
        testPinView.annotation = annotation
        testPinView.image = UIImage(named:"pin2.png")
        testPinView.canShowCallout = true
        
        return testPinView
    }
    
}
