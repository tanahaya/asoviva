//
//  ViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/08.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class nowViewController: UIViewController, CLLocationManagerDelegate  {
    
    var placePicker: GMSPlacePicker?
    var nameLabel: UILabel!
    var adressLabel: UILabel!
    var lat: CLLocationDegrees!
    var lng: CLLocationDegrees!
    var myLocationManager:CLLocationManager!
    
    var pickerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        print("authorizationStatus:\(status.rawValue)")
        if(status == .notDetermined) {
            self.myLocationManager.requestWhenInUseAuthorization()
        }
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 100
        
        
        
        self.view.backgroundColor = UIColor.white
        
        pickerButton = UIButton()
        
        pickerButton.frame = CGRect(x: self.view.frame.width / 2 - 50, y: self.view.frame.width * 3 / 4 - 20, width: 100, height: 40)
        pickerButton.backgroundColor = UIColor.red
        pickerButton.setTitle("Picker", for: .normal)
        pickerButton.addTarget(self, action: #selector(self.pickPlace(sender:)), for: .touchUpInside)
        self.view.addSubview(pickerButton)
        
        
        
        
    }
    
    func pickPlace(sender: UIButton) {
        
        myLocationManager.startUpdatingLocation()
        
        lat = myLocationManager.location!.coordinate.latitude
        lng = myLocationManager.location!.coordinate.longitude
        
        print("hello")
        print(lat)
        print(lng)
        let center = CLLocationCoordinate2DMake(lat, lng)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        
        
        
        
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlace(callback: { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            /*
             if let place = place {
             self.nameLabel.text = place.name
             self.adressLabel.text = place.formattedAddress?.components(separatedBy: (", ")).joined(separator: "\n")
             print(place.name)
             } else {
             self.nameLabel.text = "No place selected"
             self.adressLabel.text = ""
             print("習得失敗")
             }
             */
            
        })
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
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
    
}

