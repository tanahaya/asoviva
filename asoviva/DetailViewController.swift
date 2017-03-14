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

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var detailData = PlaygroundDetail()
    var label: UILabel = UILabel()
    var image: UIImageView = UIImageView()
    var tableview : UITableView = UITableView()
    var detailArray:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let posX: CGFloat = self.view.bounds.width
        let posY: CGFloat = self.view.bounds.height
        label = UILabel(frame: CGRect(x: 0, y: 50, width: posX, height: 50))
        label.backgroundColor = UIColor.orange
        label.textAlignment = NSTextAlignment.right
        self.view.addSubview(label)
        
        image = UIImageView(frame: CGRect(x:0,y:100,width: posX,height:300))
        self.view.addSubview(image)
        
        tableview = UITableView(frame: CGRect(x:0,y:400,width: posX,height: 100))
        
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
                // json["result"].array?.forEach({
                //   self.detailData = Mapper<PlaygroundDetail>().map(JSON: $0.dictionaryObject!)!
                //self.detailData.image = $0["photos"]["photo_reference"]
                //})
                
            }
            self.yomikomi()
            print(self.detailData)
        }).resume()
        
    }
    func yomikomi(){
        self.label.text = self.detailData.name
        // self.image.image = self.detailData.image  }
        detailArray.append("名前:" + detailData.name )
        detailArray.append("住所:" + detailData.address )
        detailArray.append("電話番号:" + detailData.phonenumber )
        detailArray.append("評価:" + String(detailData.rating) )
        detailArray.append("カテゴリー:" + detailData.types[0] )
        detailArray.append("ウェブサイト:" + detailData.website )
        detailArray.append("googlemapへ" + detailData.url )
        tableview.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel?.text = detailArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

