//
//  StockMemos.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/19.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Alamofire
class StockMemos: NSObject {

    // 保存ボタンが押されたときに呼ばれるメソッドを定義
    class func postMemo(memo: Memo) {
        
        var params: [String: AnyObject] = [
            "text": memo.text as AnyObject
        ]
        
        // HTTP通
        let URL = NSURL(string: "https:asoviva-server-tanahaya.c9users.io/index")
        let req = NSMutableURLRequest(url: URL! as URL)
        Alamofire.request(req , method: .post, parameters: params, encoding: .URL, headers: nil).responseJSON { (request, response, JSON, error) in
            
            println("=============request=============")
            println(request)
            println("=============response============")
            println(response)
            println("=============JSON================")
            println(JSON)
            println("=============error===============")
            println(error)
            println("=================================")
        }
        
        
    }
    
}
