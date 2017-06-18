//
//  RouteViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/31.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    var UserDafault:UserDefaults = UserDefaults()
    
    var nowlat:Double!
    var nowlng:Double!
    var goallat:Double!
    var goallng:Double!
    
    lazy var mapView: MKMapView = {
        
        let mapView: MKMapView = MKMapView()
        mapView.delegate = self
        let mapframe: CGRect = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height  - 60)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowlat = UserDafault.double(forKey: "nowlat")
        nowlng = UserDafault.double(forKey: "nowlng")
        goallng = UserDafault.double(forKey: "goallng")
        goallat = UserDafault.double(forKey: "goallng")
        
        
        self.view.addSubview(mapView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
