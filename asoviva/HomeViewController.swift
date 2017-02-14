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
import SwiftyJSON


class HomeViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate{
    
    lazy var mapView: MKMapView = {
        let mapView: MKMapView = MKMapView()
        let mapframe: CGRect = CGRect(x: 0, y: 60 + 30, width: self.view.frame.width, height: self.view.frame.height*4/7)
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
    
    var userLocation: CLLocationCoordinate2D!
    var destLocation : CLLocationCoordinate2D!

    // mapViewにアノテーションを追加.
    var Region: MKCoordinateRegion!
    var nowlat: CLLocationDegrees!
    var nowlng: CLLocationDegrees!
    lazy var locationManager:CLLocationManager = {
        
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        return locationManager
    }()
    var locations:[Location] = []
    
    lazy var storeTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height*4/7,  width: self.view.frame.width, height: 230))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    var storenames: [String] = []
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        let searchController = UISearchController(searchResultsController: nil)
        searchBar.frame = CGRect(x: 0, y: 60, width: (self.navigationController?.navigationBar.frame.width)!, height: searchController.searchBar.frame.height)
        searchBar.placeholder = "検索キーワードを入力してください"
        searchBar.delegate = self
        searchBar.showsBookmarkButton = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "調べたい遊び場を入れてね"
        searchBar.tintColor = UIColor.orange
        return searchBar
    }()
    var key = "AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        nowlat  = 35.680298// 35.681298
        // nowlng = locationManager.location!.coordinate.longitude
        nowlng = 139.766247
        self.view.addSubview(mapView)
        self.view.addSubview(storeTableView)
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
        
        locations = []
        searchBar.endEditing(true)
        let semaphore = DispatchSemaphore(value: 0)
        let encodeStr = searchBar.text!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(nowlat!),\(nowlng!)&radius=2000&sensor=true&key=\(key)&name=\(encodeStr!)"
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
            sleep(1)
            semaphore.signal()
        }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        storeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel?.text = locations[indexPath.row].storename
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView.setCenter(locations[indexPath.row].annotation.coordinate, animated: false)
        mapView.selectAnnotation(locations[indexPath.row].annotation as MKAnnotation, animated: false)
        locationManager.startUpdatingLocation()
    }
    
    //以下経路
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let detailButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "詳しく") { (action, index) -> Void in
            tableView.isEditing = false
            let nextViewController: UIViewController = DetailViewController()
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        detailButton.backgroundColor = UIColor.blue
        let guideButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "道案内") { (action, index) -> Void in
            
            self.userLocation = CLLocationCoordinate2DMake(self.nowlat,self.nowlng)
            self.destLocation = CLLocationCoordinate2DMake(self.locations[indexPath.row].lat, self.locations[indexPath.row].lng)
            let fromPlacemark = MKPlacemark(coordinate:self.userLocation, addressDictionary:nil)
            let toPlacemark   = MKPlacemark(coordinate:self.destLocation, addressDictionary:nil)
            
            // MKPlacemark から MKMapItem を生成
            let fromItem = MKMapItem(placemark:fromPlacemark)
            let toItem   = MKMapItem(placemark:toPlacemark)
            
            // MKMapItem をセットして MKDirectionsRequest を生成
            let request = MKDirectionsRequest()
            
            request.source = fromItem
            request.destination = toItem
            
            request.requestsAlternateRoutes = true // 単独の経路を検索
            request.transportType = MKDirectionsTransportType.walking
            
            let directions: MKDirections = MKDirections(request:request)
            directions.calculate { (response, error) in
                // NSErrorを受け取ったか、ルートがない場合.
                if error != nil || response!.routes.isEmpty {
                    print("noroute")
                    return
                }
                let route: MKRoute = response!.routes[0] as MKRoute
                // print("目的地まで \(route.distance)m" + "所要時間 \(Int(route.expectedTravelTime/60))分")
                // mapViewにルートを描画.
                self.mapView.add(route.polyline)
                
            }
            
            
        }
        guideButton.backgroundColor = UIColor.green
        return [detailButton,guideButton]
    }
    func showUserAndDestinationOnMap() {
        // 現在地と目的地を含む矩形を計算
        let maxLat:Double = fmax(userLocation.latitude,  destLocation.latitude)
        let maxLon:Double = fmax(userLocation.longitude, destLocation.longitude)
        let minLat:Double = fmin(userLocation.latitude,  destLocation.latitude)
        let minLon:Double = fmin(userLocation.longitude, destLocation.longitude)
        
        // 地図表示するときの緯度、経度の幅を計算
        let mapMargin:Double = 1.5;  // 経路が入る幅(1.0)＋余白(0.5)
        let leastCoordSpan:Double = 0.005;    // 拡大表示したときの最大値
        let span_x:Double = fmax(leastCoordSpan, fabs(maxLat - minLat) * mapMargin);
        let span_y:Double = fmax(leastCoordSpan, fabs(maxLon - minLon) * mapMargin);
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(span_x, span_y);
        
        // 現在地を目的地の中心を計算
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLat + minLat) / 2, (maxLon + minLon) / 2);
        let region:MKCoordinateRegion = MKCoordinateRegionMake(center, span);
        
        mapView.setRegion(mapView.regionThatFits(region), animated:true);
    }
    
    // 経路を描画するときの色や線の太さを指定
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
        routeRenderer.lineWidth = 3.0
        routeRenderer.strokeColor = UIColor.red
        return routeRenderer
    }
    
    
    
}










