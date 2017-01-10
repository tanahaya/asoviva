//
//  HomeViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/15.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

class HomeViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate{
    
    
    var mapView: MKMapView = MKMapView()
    var Region: MKCoordinateRegion!
    var lat: CLLocationDegrees!
    var lng: CLLocationDegrees!
    var locationManager:CLLocationManager!
    
    var storeTableView:UITableView!
    let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var searchBar:UISearchBar!
    
    var key = "AIzaSyCwcR3jfPvo1SNdLFTTOe0dZ1_PX_AZ2xU"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.title = "Asoviva"
        
        
        locationManager = CLLocationManager()
        let status = CLLocationManager.authorizationStatus()
        if(status == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        // locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.startUpdatingLocation()
        }
        //lat = locationManager.location!.coordinate.latitude
        lat  = 35.681298
        // lng = locationManager.location!.coordinate.longitude
        lng = 139.766247
        
        
        
        let mapframe: CGRect = CGRect(x: 0, y: 60 + 30, width: self.view.frame.width, height: self.view.frame.height*4/7)
        mapView.frame = mapframe
        let myLatitude: CLLocationDegrees = lat
        let myLongitude: CLLocationDegrees = lng
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        mapView.setCenter(center, animated: true)
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        Region = MKCoordinateRegionMake(center, mySpan)
        mapView.region = Region
        self.view.addSubview(mapView)
        
        storeTableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height*4/7,  width: self.view.frame.width, height: 260))
        storeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        storeTableView.dataSource = self
        storeTableView.delegate = self
        self.view.addSubview(storeTableView)
        
        
        
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 60, width: (self.navigationController?.navigationBar.frame.width)!, height: searchController.searchBar.frame.height)
        searchBar.placeholder = "検索キーワードを入力してください"
        // searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 50)
        searchBar.delegate = self
        searchBar.showsBookmarkButton = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "調べたい遊び場を入れてね"
        searchBar.tintColor = UIColor.orange
        self.view.addSubview(searchBar)
        
        
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        // 検索開始
        var annotationList = [MKPointAnnotation]()
        var page_token:String = ""
        repeat {
            //セマフォを使って、検索とメインスレッドを同期で処理する。
            let semaphore = DispatchSemaphore(value: 0)
            
            
            var a_key = key.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            
            let encodeStr = searchBar.text!
            let a_encodeStr = encodeStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let a_page_token = page_token.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat!),\(lng!)&radius=2000&sensor=true&key=\(key)&name=\(a_encodeStr!)"
            //&pagetoken=\(page_token)なし
            print(url)
            let testURL:URL = URL(string: url)!
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: testURL, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
                if error != nil {
                    print("\(error)")
                } else {
                    if let statusCode = response as? HTTPURLResponse {
                        if statusCode.statusCode != 200 {
                            print("\(response)")
                        }
                    }
                    do {
                        //レスポンスデータ（JSON）から辞書を作成する。
                        // let json = try JSONSerialization.JSONObjectWithData(data!, options: JSONReadingOptions.MutableContainers) as! NSDictionary
                        let json = try JSONSerialization.jsonObject(with: data!, options:  JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        let results = json["results"] as? Array<NSDictionary>
                        
                        //次のページがあるか確認する。
                        /*
                         if json["next_page_token"] != nil {
                         page_token = json["next_page_token"] as! String
                         } else {
                         page_token = ""
                         }
                         */
                        //検索結果の件数ぶんループ
                        for result in results! {
                            let annotation = MKPointAnnotation()
                            
                            //ピンのタイトルに店名、住所を設定する。
                            annotation.title = result["name"] as? String
                            annotation.subtitle = result["vicinity"] as? String
                            
                            if let geometry = result["geometry"] as? NSDictionary {
                                if let location = geometry["location"] as? NSDictionary {
                                    
                                    //ビンの座標を設定する。
                                    annotation.coordinate = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["lng"] as! CLLocationDegrees)
                                    annotationList.append(annotation)
                                    
                                }
                                
                            }
                        }
                        
                    } catch {
                        print("エラー")
                    }
                }
                //連続で要求をすると結果が返ってこないので一瞬スリープする。
                sleep(1)
                //処理終了をセマフォに知らせる。
                semaphore.signal()
            }).resume()
            
            //検索が終わるのを待つ。
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            // dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            
        } while (page_token != "")
        
        //キーボードを閉じる。
        
        //ピンをマップに追加する。
        mapView.addAnnotations(annotationList)
        
        self.view.endEditing(true)
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //　サーチバー更新時
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        return cell
    }
}






