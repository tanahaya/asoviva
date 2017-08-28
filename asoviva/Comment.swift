
//
//  Comment.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/28.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

struct Comment: Mappable{
    
    var storename:String!
    var placeId:String!
    var price:Int!
    var recommendnumber:Int!
    var time:Int!
    var writer:String!
    var photo1:String = ""
    var photo2:String = ""
    var photo3:String = ""
    var photo4:String = ""
    var title:String = ""
    var content:String = ""
    var date:String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        storename <- map["name"]
        placeId <- map["place_id"]
        price <- map["money"]
        recommendnumber <- map["recommendnumber"]
        time <- map["time"]
        writer <- map["writer"]
        photo1 <- map["photo1"]
        photo2 <- map["photo2"]
        photo3 <- map["photo3"]
        photo4 <- map["photo4"]
        title <- map["title"]
        content <- map["content"]
        date <- map["updated_at"]
    }
    
}
