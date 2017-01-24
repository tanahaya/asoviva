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
import ObjectMapper

class HomeViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate{
    
    
    var mapView: MKMapView = MKMapView()
    var Region: MKCoordinateRegion!
    var lat: CLLocationDegrees!
    var lng: CLLocationDegrees!
    var locationManager:CLLocationManager!
    var locations:[Location]!
    var storeTableView:UITableView!
    var storenames: [String] = []
    var annotationList = [MKPointAnnotation]()
    var searchController = UISearchController(searchResultsController: nil)
    var searchBar:UISearchBar!
    var key = "AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
    
    
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
        lat  = 35.680298// 35.681298
        // lng = locationManager.location!.coordinate.longitude
        lng = 139.766247
        
        let mapframe: CGRect = CGRect(x: 0, y: 60 + 30, width: self.view.frame.width, height: self.view.frame.height*4/7)
        mapView.frame = mapframe
        let myLatitude: CLLocationDegrees = lat
        let myLongitude: CLLocationDegrees = lng
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        mapView.setCenter(center, animated: true)
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        Region = MKCoordinateRegionMake(center, mySpan)
        mapView.region = Region
        self.view.addSubview(mapView)
        
        storeTableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height*4/7,  width: self.view.frame.width, height: 230))
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
        
        storenames = []
        searchBar.endEditing(true)
        
        let page_token:String = ""
        let semaphore = DispatchSemaphore(value: 0)
        /*
         repeat {
         //セマフォを使って、検索とメインスレッドを同期で処理する。
         let semaphore = DispatchSemaphore(value: 0)
         _ = key.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
         let encodeStr = searchBar.text!
         let a_encodeStr = encodeStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
         _ = page_token.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
         
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
         let json = try JSONSerialization.jsonObject(with: data!, options:  JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
         let results = json["results"] as? Array<NSDictionary>
         
         for result in results! {
         let annotation = MKPointAnnotation()
         
         let location: Location = Mapper<Location>().map(JSONObject: result)!
         // self.locations.append(location)
         self.storenames.append((result["name"] as? String)!)
         // self.annotationList.append((result["locaiton"] as? MKPointAnnotation)! )
         
         if let geometry = result["geometry"] as? NSDictionary {
         if let location = geometry["location"] as? NSDictionary {
         
         //ビンの座標を設定する。
         annotation.coordinate = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["lng"] as! CLLocationDegrees)
         self.annotationList.append(annotation)
         
         }
         }
         }
         
         } catch {
         print("エラー")
         }
         }
         sleep(1)
         //処理終了をセマフォに知らせる。
         semaphore.signal()
         }).resume()
         //検索が終わるのを待つ。
         _ = semaphore.wait(timeout: DispatchTime.distantFuture)
         } while (page_token != "")
         //ピンをマップに追加する。
         */
            let encodeStr = searchBar.text!
            let a_encodeStr = encodeStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat!),\(lng!)&radius=2000&sensor=true&key=\(key)&name=\(a_encodeStr!)"
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
                        let json = try JSONSerialization.jsonObject(with: data!, options:  JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        let results = json["results"] as? Array<NSDictionary>
                        for result in results! {
                            let annotation = MKPointAnnotation()
                            let location: Location = Mapper<Location>().map(JSONObject: result)!
                            // self.locations.append(location)
                            self.storenames.append((result["name"] as? String)!)
                            // self.annotationList.append((result["locaiton"] as? MKPointAnnotation)! )
                            if let geometry = result["geometry"] as? NSDictionary {
                                if let location = geometry["location"] as? NSDictionary {
                                    //ビンの座標を設定する。
                                    annotation.coordinate = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["lng"] as! CLLocationDegrees)
                                    self.annotationList.append(annotation)
                                }
                            }
                        }
                        
                    } catch {
                        print("エラー")
                    }
                }
                sleep(1)
                //処理終了をセマフォに知らせる。
                semaphore.signal()
            }).resume()
            //検索が終わるのを待つ。
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            storeTableView.reloadData()
        
        //  mapView.addAnnotations(locations[].location as! [MKAnnotation])
        //mapView.addAnnotation(annotationList as! MKAnnotation)
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView.setCenter(self.annotationList[indexPath.row].coordinate, animated: false)
        mapView.selectAnnotation(self.annotationList[indexPath.row], animated: true)
        
        locationManager.startUpdatingLocation()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storenames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        //cell.textLabel?.text = locations[indexPath.row].storename
        cell.textLabel?.text = storenames[indexPath.row]
        return cell
        
    }
    
    
}






