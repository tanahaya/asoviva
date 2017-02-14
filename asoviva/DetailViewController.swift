//
//  DetailViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/02/07.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import ObjectMapper
import SwiftyJSON

class DetailViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let posX: CGFloat = self.view.bounds.width/2 - 100
        let posY: CGFloat = self.view.bounds.height/2 - 25
        let label: UILabel = UILabel(frame: CGRect(x:posX, y: posY, width: 200, height: 50))
        label.backgroundColor = UIColor.orange
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.white
        let userDefaults = UserDefaults.standard
        
        let detaildata:[Detail] = []
        
        let placeid:String = userDefaults.string(forKey: "detail")!
        
        let url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeid)&key=AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
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
                let json = JSON(data)
                json["results"].array?.forEach({
                    var detail:Detail = Mapper<Detail>().map(JSON: $0.dictionaryObject!)!
                    //location.lat = $0["geometry"]["location"]["lat"].doubleValue
                    //location.lng = $0["geometry"]["location"]["lng"].doubleValue
                    
                })
                
            }
        }).resume()
        label.text = detaildata[0].name
        
        
    }
    
    
    
}

