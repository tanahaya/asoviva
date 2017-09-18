//
//  FavoriteViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/09.
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

class FavoriteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource ,CLLocationManagerDelegate {
    
    let UserDefault = UserDefaults.standard
    var favorites:[favorite] = []
    
    let realm = try! Realm()
    var sendernumber:Int = 0
    
    var nowlat: CLLocationDegrees!
    var nowlng: CLLocationDegrees!
    
    lazy var storeTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0,  width: self.view.frame.width, height: 667))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "storeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "storeTableViewCell")
        return tableView
    }()
    
    lazy var locationManager:CLLocationManager = {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 300
        return locationManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         try! realm.write {
         realm.deleteAll()
         }
         */
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.view.addSubview(storeTableView)
        
        self.navigationItem.title  = "Asoviva"
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        favorites = favorite.loadAll()
        if favorites.count == 0 {
            
            let alert = SCLAlertView()
            alert.labelTitle.font =  UIFont.systemFont(ofSize: 13)
            
            alert.showSuccess("お気に入り登録がまだです。", subTitle: "遊び場をお気に入り登録しましょう")
        }
        storeTableView.reloadData()
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
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nowfavorite = favorites[indexPath.row]
        
        
        let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
        cell.nameLabel.text = nowfavorite.storename
        
        if nowfavorite.price == 0 {
            cell.priceLabel.text = "--円"
        }else {
            cell.priceLabel.text = " \(nowfavorite.price)" + "円"
        }
        if nowfavorite.recommendnumber == 0 {
            cell.favoriteLabel.text = "--点"
        }else {
            cell.favoriteLabel.text = "\( Double(nowfavorite.recommendnumber) / 10.0 )" + "点"
        }
        
        
        cell.commentLabel.text = "\(nowfavorite.commentnumber)" + "つ"
        if indexPath.row == 0{
            cell.photoLabel.text = "4枚"
            cell.distanceLabel.text = "8分"
        }else {
            cell.photoLabel.text = "0枚"
            cell.distanceLabel.text = "\(arc4random_uniform(10) + 7 )" + "分"
        }
        
        if nowfavorite.storename.characters.count > 24 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 10)
        }else if nowfavorite.storename.characters.count > 19 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 12)
        }else if nowfavorite.storename.characters.count > 14 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
        }else  {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        if nowfavorite.photo1 == nil{
            
            cell.storeimage1.image = UIImage(named:"nophoto.png")
            cell.storeimage2.image = UIImage(named:"nophoto.png")
            cell.storeimage3.image = UIImage(named:"nophoto.png")
            cell.storeimage4.image = UIImage(named:"nophoto.png")
            
        }else {
            let dataDecoded1 : Data = Data(base64Encoded: nowfavorite.photo1!, options: .ignoreUnknownCharacters)!
            let decodedimage1 = UIImage(data: dataDecoded1)
            cell.storeimage1.image = decodedimage1
            
            let dataDecoded2 : Data = Data(base64Encoded: nowfavorite.photo2!, options: .ignoreUnknownCharacters)!
            let decodedimage2 = UIImage(data: dataDecoded2)
            cell.storeimage2.image = decodedimage2
            
            let dataDecoded3 : Data = Data(base64Encoded: nowfavorite.photo3!, options: .ignoreUnknownCharacters)!
            let decodedimage3 = UIImage(data: dataDecoded3)
            cell.storeimage3.image = decodedimage3
            
            let dataDecoded4 : Data = Data(base64Encoded: nowfavorite.photo4!, options: .ignoreUnknownCharacters)!
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
        var scheme: String! =  self.favorites[sender.tag].storename + "\n" + "asoviva://" + self.favorites[sender.tag].placeid
        
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
        if favorites[sender.tag].commentnumber == 0{
            alert.addButton("コメントを投稿する", action: {
                self.UserDefault.set(self.favorites[sender.tag].placeid, forKey: "place_id")
                self.UserDefault.set(self.favorites[sender.tag].storename, forKey: "place_name")
                let postcommentview = postcommentFormViewController()
                self.navigationController?.pushViewController(postcommentview, animated: true)
            })
            alert.showNotice("コメントがまだありません", subTitle: "コメントを書きますか?")
        }else{
            self.UserDefault.set(self.favorites[sender.tag].placeid, forKey: "place_id")
            self.UserDefault.set(self.favorites[sender.tag].storename, forKey: "place_name")
            let commentview = commentViewController()
            self.navigationController?.pushViewController(commentview, animated: true)
        }
    }
    
    func distancebutton(sender: UIButton){
        print("distance")
        UserDefault.set(nowlat, forKey: "nowlat")
        UserDefault.set(nowlng, forKey: "nowlng")
        UserDefault.set(favorites[sender.tag].lat, forKey: "goallat")
        UserDefault.set(favorites[sender.tag].lng, forKey: "goallng")
        let routeview = RouteViewController()
        self.navigationController?.pushViewController( routeview, animated: true)
    }
    func favoritebutton(sender: UIButton) {
        print("favorite")
        
        let alert = SCLAlertView()
        alert.labelTitle.font =  UIFont.systemFont(ofSize: 15)
        alert.addButton("お気に入り解除", action: {
            
            let item = self.favorites[sender.tag]
            
            try! self.realm.write {
                self.realm.delete(item)
            }
            self.favorites.remove(at: sender.tag)
            self.storeTableView.reloadData()
            
        })
        alert.showNotice("お気に入り解除しますか", subTitle: "")
    }
    
    func photobutton(sender: UIButton) {
        print("photo")
        if favorites[sender.tag].photonumber == 0{
            let alert = SCLAlertView()
            alert.labelTitle.font =  UIFont.systemFont(ofSize: 15)
            alert.showSuccess("写真がありません", subTitle: "")
        }else{
            UserDefault.set(favorites[sender.tag].placeid, forKey: "place_id")
            let showImage = showImageViewController()
            self.navigationController?.pushViewController(showImage, animated: true)
        }
        
    }
    func timebutton(sender: UIButton) {
        
        print("time")
        /*
         if favorites[sender.tag].opennow{
         SCLAlertView().showInfo("現在、開店中です。", subTitle: "")
         }else {
         SCLAlertView().showInfo("現在、閉店中です。", subTitle: "")
         }
         */
    }
    
    func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("failed to open..")
        }
    }
}
