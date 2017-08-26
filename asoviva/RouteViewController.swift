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
    
    var userLocation: CLLocationCoordinate2D!
    var destLocation: CLLocationCoordinate2D!
    var start: CLLocationCoordinate2D!
    var goal: CLLocationCoordinate2D!
    
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
        goallat = UserDafault.double(forKey: "goallat")
        goallng = UserDafault.double(forKey: "goallng")
        print(goallat)
        print(goallng)
        self.pin(lat: nowlat, lng: nowlng, goallat: goallat, goallng: goallng)
        self.view.addSubview(mapView)
        
        // Do any additional setup after loading the view.
    }
    
    func pin(lat:Double,lng:Double,goallat:Double,goallng:Double){
        
        let nowPin: MKPointAnnotation = MKPointAnnotation()
        start = CLLocationCoordinate2DMake( lat, lng)
        nowPin.coordinate = start
        nowPin.title = "START"
        nowPin.subtitle = ""
        mapView.addAnnotation(nowPin)
        
        let goalPin: MKPointAnnotation = MKPointAnnotation()
        goal = CLLocationCoordinate2DMake( goallat, goallng)
        goalPin.coordinate = goal
        goalPin.title = "GOAL"
        goalPin.subtitle = ""
        mapView.addAnnotation(goalPin)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let testPinView = MKPinAnnotationView()
        testPinView.annotation = annotation
        testPinView.pinTintColor = UIColor.red
        testPinView.canShowCallout = true
        
        return testPinView
    }
    
}
