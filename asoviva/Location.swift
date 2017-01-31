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
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        storename <- map["name"]
        lat <- map["geometry"]["location"]["lat"]
        lng <- map["geometry"]["location"]["lng"]
        vicinity <- map["vicinity"]
    }

}
