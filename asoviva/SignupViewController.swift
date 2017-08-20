//
//  SignupViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/20.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class SignupViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.navigationItem.title  = "Asoviva"
        // Do any additional setup after loading the view.
    }
    func setup() {
        
        form +++ Section("ユーザー情報")
            <<< TextRow("ユーザー名"){ row in
                row.title = "ユーザー名"
                row.placeholder = "ユーザー名を決めて下さい"
            }
            <<< TextRow("学校"){ row in
                row.title = "学校"
                row.placeholder = "あなたの学校を打ち込んで下さい"
            }
            <<< EmailRow("メールアドレス"){ row in
                row.title = "メールアドレス"
                row.placeholder = "メールアドレスを打ち込んで下さい"
            }
            
            <<< PasswordRow("パスワード"){ row in
                row.title = "パスワード"
                row.placeholder = "パスワードを決めて下さい"
                
            }
        
        
        form +++ Section("ユーザー情報")
            <<< ButtonRow("登録"){ row in
            row.title = "登録"
                }.onCellSelection(){row in
                    
                    let params: [String: Any] = [
                        "user": TextRow("ユーザー名").value ?? String() ,"email": TextRow("学校").value ?? String(),"school": PasswordRow("パスワード").value ?? String(),"password": EmailRow("メールアドレス").value ?? String()
                    ]
                    
                    Alamofire.request("https://asovivaserver-tanahaya.c9users.io/api/users" , method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                    }
                    
                    let MyPageController = MyPageViewController()
                    // webviewController.url = locations[sender.tag]
                    self.navigationController?.pushViewController(MyPageController, animated: true)
                    
        }

        
    }
    
}
