//
//  location.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/01/24.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import ObjectMapper
import MapKit
import SwiftyJSON

struct Location: Mappable{
    
    var storename:String!
    var lat:Double!
    var lng:Double!
    var vicinity:String!
    var annotation = MKPointAnnotation()
    var placeId:String!
    var price:Int!
    var commentnumber:Int!
    var recommendnumber:Int!
    var photonubmer:Int!
    var photos:[String]?
    var opennow:Bool!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        storename <- map["name"]
        vicinity <- map["vicinity"]
        placeId <- map["place_id"]
        price <- map["price"]
        commentnumber <- map["commentnumber"]
        recommendnumber <- map["recommendnumber"]
        photos <- map["photos"]
        photonubmer <- map["photonumber"]
    }

}
