//
//  postcommentViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/22.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON

class postcommentFormViewController:FormViewController {
    
    let userDefaults = UserDefaults.standard
    var comment: [String: Any] = ["title": "タイトル","content": "Hello,world","time": 1.0,"money": 1000,"recommendnumber": 5.0,"place_id": "aaaa"]
    var params: [String: Any] = [:]
    //var params:[String:Any] = ["microposts":["content":"Hello,world"],"user_id":1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        params["user_id"] = userDefaults.dictionary(forKey: "userinformation")?["user_id"]
        
        print(params)
        
        self.navigationItem.title  = "Asoviva"
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        
        form +++ Section("ユーザー情報")
            <<< TextRow("タイトル"){ row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入れて下さい"
                }.onChange(){row in
                    self.comment["title"] = row.value
            }
            <<< SliderRow() {
                $0.title = "おすすめ度"
                $0.minimumValue = 1.0
                $0.maximumValue = 5.0
                $0.value = 5.0
                }.onChange(){row in
                    self.comment["recommentnumber"] = row.value
                    
            }
            
            <<< SliderRow() {
                $0.title = "過ごした時間"
                $0.value = 1.0
                }.onChange(){row in
                    self.comment["time"] = row.value
                    
            }
            
            <<< SliderRow() {
                $0.title = "値段"
                $0.minimumValue = 0
                $0.maximumValue = 10000
                $0.value = 1000
                }.onChange(){row in
                    self.comment["money"] = row.value
            }
            
            <<< TextAreaRow("口コミ本文") {
                $0.placeholder = "口コミ本文を入れて下さい"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 100)
                }.onChange(){row in
                    self.comment["content"] = row.value
        }
        
        form +++ Section("投稿")
            <<< ButtonRow("投稿する"){ row in
                row.title = "投稿する"
                
                }.onCellSelection(){row in
                    self.params["microposts"] = self.comment
                    print(self.params)
                    
                    Alamofire.request("https://server-tanahaya.c9users.io/api/microposts" , method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                        // print(response.result.value!)
                        
                    }
                    //let MyPageController = MyPageViewController()
                    self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    //self.navigationController?.pushViewController(MyPageController, animated: true)
                    
        }
        
    }
    
}
