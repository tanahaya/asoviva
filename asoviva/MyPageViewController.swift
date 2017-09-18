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
    
    let UserDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.navigationItem.title  = "Asoviva"
        self.navigationItem.hidesBackButton = true
        
    }
    func alert(){
        SCLAlertView().showInfo("準備中", subTitle: "")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        print(self.UserDefault.string(forKey: "username") ?? String())
        
        let row: CustomButtonRow? = self.form.rowBy(tag: "user")
        
        if self.UserDefault.bool(forKey: "signup") == false {
            row?.cell.nameLabel.text = self.UserDefault.string(forKey: "username") ?? String()
        }else if self.UserDefault.bool(forKey: "signup"){
            print("ユーザー未登録")
        }
    }
    func setup() {
        self.form +++ Section("user")
            
            <<< CustomButtonRow("user") {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "ユーザー未登録"
                })
                }.onCellSelection(){row in
                    
                    if self.UserDefault.bool(forKey: "signup") == false {
                        
                        print("Signup済み")
                    }else if self.UserDefault.bool(forKey: "signup"){
                        
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
