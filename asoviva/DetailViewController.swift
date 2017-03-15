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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let posX: CGFloat = self.view.bounds.width
        let posY: CGFloat = self.view.bounds.height
        
        self.view.backgroundColor = UIColor.white
        let encodeplaceid = detailData.placeId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url:String! = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(encodeplaceid!)&key=AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
        let TestURL:URL = URL(string: url)!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: TestURL, completionHandler: { (data : Data?, response : URLResponse?, error : Error?) in
            if error != nil {
                print("Error: " + "\(error)")
            } else {
                if let statusCode = response as? HTTPURLResponse {
                    if statusCode.statusCode != 200 {
                        print("Response: " + "\(response)")
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
    func yomikomi(){
        // self.image.image = self.detailData.image  }
        /*
         detailArray.append("名前:" + detailData.name )
         detailArray.append("住所:" + detailData.address )
         detailArray.append("電話番号:" + detailData.phonenumber )
         detailArray.append("評価:" + String(detailData.rating) )
         detailArray.append("カテゴリー:" + detailData.types[0] )
         //定休日
         //予算
         //交通手段
         //今開いているか
         //
         detailArray.append("ウェブサイト:" + detailData.website )
         detailArray.append("googlemapへ" + detailData.url )
         */
        
    }
    func setup() {
        self.form +++ Section("お店の名前")
            <<< LabelRow() {
                $0.title = "名前:" + detailData.name
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
            // <<< CustomImageCell() { row in
               //row.value = detailData.image
        //}
        
    }
    
}


