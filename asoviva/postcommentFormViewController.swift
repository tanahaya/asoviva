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

class postcommentFormViewController:FormViewController {
    
    var params: [String: Any] = [
        "title": "","content": "","time": 0,"money": 0,"recommentnumber": 0,"user_id": 0,"placeid": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.navigationItem.title  = "Asoviva"
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        
        form +++ Section("ユーザー情報")
            <<< TextRow("タイトル"){ row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入れて下さい"
                }.onChange(){row in
                    
            }
            <<< SliderRow() {
                $0.title = "おすすめ度"
                $0.value = 5.0
                }.onChange(){row in
                    
            }
            
            <<< SliderRow() {
                $0.title = "過ごした時間"
                $0.value = 5.0
                }.onChange(){row in
                    
            }
            
            <<< SliderRow() {
                $0.title = "値段"
                $0.value = 1000
                }.onChange(){row in
                    
            }
            <<< TextAreaRow("口コミ本文") {
                $0.placeholder = "口コミ本文を入れて下さい"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
                }.onChange(){row in
                    
        }
        
        form +++ Section("投稿")
            <<< ButtonRow("投稿する"){ row in
                row.title = "投稿する"
                
                }.onCellSelection(){row in
                    
                    Alamofire.request("https://asovivaserver-tanahaya.c9users.io/api/micropost" , method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                    }
                    
                    let MyPageController = MyPageViewController()
                    //self.navigationController?.pushViewController(MyPageController, animated: true)
                    
        }
        
        
    }
    
    
}
