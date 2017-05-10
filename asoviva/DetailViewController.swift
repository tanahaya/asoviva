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
import Eureka

class DetailViewController: FormViewController {
    
    var detailData = PlaygroundDetail()
    var detailArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        let encodeplaceid = detailData.placeId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url:String! = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(encodeplaceid!)&key=AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
        let TestURL:URL = URL(string: url)!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: TestURL, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
            if error != nil {
                print("Error: " + "\(String(describing: error))")
            } else {
                if let statusCode = response as? HTTPURLResponse {
                    if statusCode.statusCode != 200 {
                        print("Response: " + "\(String(describing: response))")
                    }
                }
                guard let data:Data = data else {return}
                let json:JSON = JSON(data)
                self.detailData = Mapper<PlaygroundDetail>().map(JSON: json["result"].dictionaryObject!)!
                json["result"].array?.forEach({_ in
                    //   self.detailData = Mapper<PlaygroundDetail>().map(JSON: $0.dictionaryObject!)!
                    //self.detailData.image = $0["photos"]["photo_reference"]
                    
                })
                
            }
            self.setup()
            print(self.detailData)
        }).resume()
        
    }
    
    func setup() {
        self.form +++ Section("お店の名前")
            <<< LabelRow() {
                $0.title = "名前:" + detailData.name
            }
            +++ Section()
            <<< CustomRow() {
                
                $0.cellSetup({ (cell, row) in
                    let nowimage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:50,height:50))
                    cell.customImage.image = nowimage
                    
                })
                
                
            }
            
            +++ Section("お店の画像")
            <<< LabelRow(){
                $0.title = "Date Row"
            }
            +++ Section("お店の情報")
            <<< LabelRow() {
                $0.title = "住所:" + detailData.address
            }
            <<< LabelRow() {
                $0.title = "電話番号:" + detailData.phonenumber
            }
            <<< LabelRow() {
                $0.title = "評価:" + String(detailData.rating)
            }
            <<< LabelRow() {
                $0.title = "電話番号:" + detailData.phonenumber
            }
            <<< LabelRow() {
                $0.title = "ウェブサイト:" + detailData.website
            }
            <<< LabelRow() {
                $0.title = "カテゴリー:" + detailData.types[0]
        }
        
    }
    
}


