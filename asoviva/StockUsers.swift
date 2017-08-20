//
//  StockMemos.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/19.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Alamofire
class StockUsers: NSObject {
    
    // 保存ボタンが押されたときに呼ばれるメソッドを定義
    class func postMemo(user: User) {
        
        var params: [String: Any] = [
            "user": user.text,"email": user.text,"school": user.text,"password": user.text
        ]
        
        
        Alamofire.request("https://asovivaserver-tanahaya.c9users.io/api/users" , method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            
        }
        
        
    }
    
}
