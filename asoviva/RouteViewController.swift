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
import Chameleon

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
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowlat = UserDafault.double(forKey: "nowlat")
        nowlng = UserDafault.double(forKey: "nowlng")
        goallat = UserDafault.double(forKey: "goallat")
        goallng = UserDafault.double(forKey: "goallng")
        
        let requestCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(goallat, goallng)
        let fromCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake( nowlat, nowlng)
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake((nowlat + goallat)/2, ( nowlng + goallng)/2)
        mapView.setCenter(center, animated: true)
        
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegionMake(center, mySpan)
        mapView.region = region
        
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
            print("目的地まで \(route.distance)km")
            print("所要時間 \(Int(route.expectedTravelTime/60))分")
            
            self.mapView.add(route.polyline)
        }
        
        let fromPin: MKPointAnnotation = MKPointAnnotation()
        let toPin: MKPointAnnotation = MKPointAnnotation()
        
        fromPin.coordinate = fromCoordinate
        toPin.coordinate = requestCoordinate
        
        
        
        fromPin.title = "出発地点"
        toPin.title = "目的地"
        
        mapView.addAnnotation(fromPin)
        mapView.addAnnotation(toPin)
        
        self.view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
        // ルートの線の太さ.
        routeRenderer.lineWidth = 10.0
        // ルートの線の色.
        routeRenderer.strokeColor = UIColor.flatYellowColorDark()
        return routeRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let testPinView = MKAnnotationView()
        
        testPinView.annotation = annotation
        testPinView.image = UIImage(named:"pin2.png")
        testPinView.canShowCallout = true
        
        return testPinView
    }
    
}
