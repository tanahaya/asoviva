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

struct Location: Mappable{
    
    var storename:String!
    var location:MKAnnotation!
    
    init?(map: Map) {
       
        
    }
    
    mutating func mapping(map: Map) {
        storename <- map["storename"]
        location <- map["location"]
    }

}
