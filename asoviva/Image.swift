//
//  Image.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/30.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

struct Image: Mappable{
    
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
        
        storename <- map["photo"]
        
    }
    
}

