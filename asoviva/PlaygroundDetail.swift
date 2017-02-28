//
//  detail.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/02/14.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import ObjectMapper
import MapKit
import SwiftyJSON

struct PlaygroundDetail: Mappable{
    
    var placeId: String!
    var name:String!
    var address:String!
    var phonenumber:String!
    var icon:UIImage!
    var rating:Double!
    var types:[String]!
    var url:String!
    var vicinity:String!
    var website:String!
    
    init?(map: Map) {
        
    }
    init(){
        
    }
    
    mutating func mapping(map: Map) {
        placeId <- map["place_id"]
        address <- map["formatted_address"]
        phonenumber <- map["formatted_phone_number"]
        icon <- map["icon"]
        name <- map["name"]
        rating <- map["rating"]
        types <- map["types"]
        url <- map["url"]
        vicinity <- map["vicinity"]
        website <- map["website"]
        
    }
    
}
