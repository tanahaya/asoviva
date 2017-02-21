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
    
    var detailData: PlaygroundDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let posX: CGFloat = self.view.bounds.width/2 - 100
        let posY: CGFloat = self.view.bounds.height/2 - 25
        let label: UILabel = UILabel(frame: CGRect(x:posX, y: posY, width: 200, height: 50))
        label.backgroundColor = UIColor.orange
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.white
        
        
        
        let url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(detailData.placeId)&key=AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
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
                    var detail:PlaygroundDetail = Mapper<PlaygroundDetail>().map(JSON: $0.dictionaryObject!)!
                    //location.lat = $0["geometry"]["location"]["lat"].doubleValue
                    //location.lng = $0["geometry"]["location"]["lng"].doubleValue
                    
                })
                
            }
        }).resume()
    }
    
    
    
}

