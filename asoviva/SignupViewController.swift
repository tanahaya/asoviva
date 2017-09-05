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
    
    let userDefaults = UserDefaults.standard
    
    var params: [String: Any] = ["username": "","email": "","school": "","password": ""]
    var add:[String:Any] = [:]
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
                row.placeholder = "username"
                }.onChange(){row in
                    self.params["username"] = row.value ?? String()
            }
            
            <<< TextRow("学校"){ row in
                row.title = "学校"
                row.placeholder = "school"
                }.onChange(){row in
                    self.params["school"] = row.value ?? String()
            }
            <<< EmailRow("メールアドレス"){ row in
                row.title = "メールアドレス"
                row.placeholder = "email"
                }.onChange(){row in
                    self.params["email"] = row.value ?? String()
            }
            
            <<< PasswordRow("パスワード"){ row in
                row.title = "パスワード"
                row.placeholder = "password"
                
                }.onChange(){row in
                    self.params["password"] = row.value ?? String()
        }
        
        form +++ Section("ユーザー情報")
            <<< ButtonRow("登録"){ row in
                row.title = "登録"
                
                }.onCellSelection(){row in
                    
                    Alamofire.request("https://server-tanahaya.c9users.io/api/signup" , method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                        print(response.result.value!)
                        self.add = response.result.value as! [String : Any]
                        self.params["usertoken"] = self.add["usertoken"]
                        print(self.params)
                        self.userDefaults.set( self.params, forKey: "userinformation")
                    }
                    
                    if self.userDefaults.bool(forKey: "signup") {
                        self.userDefaults.set(false, forKey: "signup")
                        print("初回起動")
                    }
                    
                    SCLAlertView().showInfo("ユーザー登録完了", subTitle: "")
                    
                    let MyPageController = MyPageViewController()
                    self.navigationController?.pushViewController(MyPageController, animated: true)
        }
        
    }
    
}
