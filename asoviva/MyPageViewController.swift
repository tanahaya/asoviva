//
//  MyPageViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/12.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka

class MyPageViewController: FormViewController {
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        print(self.userDefaults.dictionary(forKey: "userinformation")?["username"] ?? String())
        if self.userDefaults.bool(forKey: "signup") == false {
            let row: CustomRow? = self.form.rowBy(tag: "user")
            row?.cell.nameLabel.text = self.userDefaults.dictionary(forKey: "userinformation")?["username"] as? String
            print(row?.cell.nameLabel.text ?? String())
        }else if self.userDefaults.bool(forKey: "signup"){
            print("ユーザー未登録")
        }
        
        self.navigationItem.title  = "Asoviva"
        self.navigationItem.hidesBackButton = true
        
    }
    func alert(){
        SCLAlertView().showInfo("準備中", subTitle: "")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if self.userDefaults.bool(forKey: "signup") == false {
            let row: CustomRow? = self.form.rowBy(tag: "user")
            row?.cell.nameLabel.text = self.userDefaults.dictionary(forKey: "userinformation")?["username"] as? String
            print(row?.cell.nameLabel.text ?? String())
        }else if self.userDefaults.bool(forKey: "signup"){
            print("ユーザー未登録")
        }
    }
    func setup() {
        self.form +++ Section("user")
            
            <<< CustomRow() {
                $0.cellSetup({ (cell, row) in
                    cell.customImage.frame = CGRect(x: 20, y: 20, width:80 , height: 80)
                    cell.customImage.layer.position =  CGPoint(x: 50, y: 50)
                    
                    cell.customImage.layer.masksToBounds = true
                    cell.customImage.layer.cornerRadius = 40
                    cell.customImage.image = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.black, size: CGSize(width:80,height:80))
                    
                })
                
                }.onCellSelection(){row in
                    
                    if self.userDefaults.bool(forKey: "signup") == false {
                        
                        self.userDefaults.set(true, forKey: "signup")
                        print("Signup済み")
                    }else if self.userDefaults.bool(forKey: "signup"){
                        
                        let SignupController = SignupViewController()
                        self.navigationController?.pushViewController(SignupController, animated: true)
                    }
                    
        }
        
        self.form +++ Section("")
            
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "学生登録"
                })
                }.onCellSelection(){row in
                    self.alert()
            }

            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "通知設定"
                })
                }.onCellSelection(){row in
                    self.alert()
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "アカウント設定"
                })
                }.onCellSelection(){row in
                    self.alert()
        }
        
        self.form +++ Section("")
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "レビューとお問い合わせ"
                })
                }.onCellSelection(){row in
                    self.alert()
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "利用規約"
                })
                }.onCellSelection(){row in
                    self.alert()
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "Third Party Software"
                })
                }.onCellSelection(){row in
                    self.alert()
        }
    }
}
