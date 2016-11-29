//
//  firstViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/15.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class firstViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating{
    
    
    var mapView: MKMapView = MKMapView()
    var myRegion: MKCoordinateRegion!
    var lat: CLLocationDegrees!
    var lng: CLLocationDegrees!
    var locationManager:CLLocationManager!
    
    var storeTableView:UITableView!
    let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var searchBar:UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        locationManager = CLLocationManager()
        let status = CLLocationManager.authorizationStatus()
        print("authorizationStatus:\(status.rawValue)")
        if(status == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        lat = locationManager.location!.coordinate.latitude
        lng = locationManager.location!.coordinate.longitude
        
       
        var mapframe: CGRect = CGRect(x: 0, y: 60 + searchController.searchBar.frame.height, width: self.view.frame.width, height: self.view.frame.height*4/7)
        mapView.frame = mapframe
        let myLatitude: CLLocationDegrees = lat
        let myLongitude: CLLocationDegrees = lng
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        mapView.setCenter(center, animated: true)
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        myRegion = MKCoordinateRegionMake(center, mySpan)
        mapView.region = myRegion
        self.view.addSubview(mapView)
        
        storeTableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height*4/7,  width: self.view.frame.width, height: 260))
        storeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        storeTableView.dataSource = self
        storeTableView.delegate = self
        self.view.addSubview(storeTableView)
        
        
        /*
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        let searchframe: CGRect = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: (self.navigationController?.navigationBar.frame.width)!, height: searchController.searchBar.frame.height)
        searchController.searchBar.frame = searchframe
        self.navigationController?.navigationBar.addSubview(searchController.searchBar)
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
        */
        
        
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: (self.navigationController?.navigationBar.frame.width)!, height: searchController.searchBar.frame.height)
        searchBar.placeholder = "検索キーワードを入力してください"
        searchBar.delegate = self
        searchBar.showsBookmarkButton = false
        self.view.addSubview(searchBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: Selector("handleKeyboardWillShowNotification:"), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    func handleKeyboardWillShowNotification(notification: NSNotification) {
        searchBar.showsCancelButton = true
    }
    
    // キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスをはずす
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var navbarFrame = self.navigationController!.navigationBar.frame
        navbarFrame.size = CGSize(width: navbarFrame.width, height: navbarFrame.height + searchController.searchBar.frame.height)
        self.navigationController?.navigationBar.frame = navbarFrame
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        var statusStr: String = "";
        switch (status) {
        case .notDetermined:
            statusStr = "未認証の状態"
        case .restricted:
            statusStr = "制限された状態"
        case .denied:
            statusStr = "許可しない"
        case .authorizedAlways:
            statusStr = "常に使用を許可"
        case .authorizedWhenInUse:
            statusStr = "このAppの使用中のみ許可"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        storeTableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.endEditing(true)
        
    }
    
    
    
}
