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
    
    var params: [String: Any] = [
        "username": "","email": "","school": "" ,"password": ""]
    
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
                }.onChange(){row in
                    self.params["username"] = row.value ?? String()
            }
            
            <<< TextRow("学校"){ row in
                row.title = "学校"
                row.placeholder = "あなたの学校を打ち込んで下さい"
                }.onChange(){row in
                    self.params["school"] = row.value ?? String()
            }
            <<< EmailRow("メールアドレス"){ row in
                row.title = "メールアドレス"
                row.placeholder = "メールアドレスを打ち込んで下さい"
                }.onChange(){row in
                    self.params["email"] = row.value ?? String()
            }
            
            <<< PasswordRow("パスワード"){ row in
                row.title = "パスワード"
                row.placeholder = "パスワードを決めて下さい"
                
                }.onChange(){row in
                    self.params["password"] = row.value ?? String()
        }
        
        
        form +++ Section("ユーザー情報")
            <<< ButtonRow("登録"){ row in
                row.title = "登録"
                
                }.onCellSelection(){row in
                    
                    self.params["username"] = "tanahaya"
                    self.params["school"] = "seiko"
                    self.params["email"] = "tanahaya00623@gmail.com"
                    self.params["password"] = "hayate"
                    
                    Alamofire.request("https://asovivaserver-tanahaya.c9users.io/api/signup" , method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                    }
                    
                    let MyPageController = MyPageViewController()
                    // self.navigationController?.pushViewController(MyPageController, animated: true)
                    
                    let content: [String: Any] = [ "email": "tanahaya00623@gmail.com","content": "ajfeoai;nvoeajfeoai;nvoeajfeoai;nvoeajfeoai;nvoeajfeoai;nvoeajfe"]
                    Alamofire.request("https://asovivaserver-tanahaya.c9users.io/api/microposts" , method: .post, parameters: content, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                    }
                    
        }
        
    }
    
}
