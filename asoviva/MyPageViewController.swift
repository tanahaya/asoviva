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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        // Do any additional setup after loading the view.
    }
    func setup() {
        self.form +++ Section("")
            
            <<< CustomRow() {
                $0.cellSetup({ (cell, row) in
                    cell.customImage.frame = CGRect(x: 20, y: 20, width:80 , height: 80)
                    cell.customImage.layer.position =  CGPoint(x: 50, y: 50)
                    //let nowimage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:100,height:100))
                    
                    let nowImage: UIImage = UIImage(named: "sampleimage.jpg")!
                    cell.customImage.layer.masksToBounds = true
                    cell.customImage.layer.cornerRadius = 40
                    cell.customImage.image = nowImage
                    
                })
                
        }
        
        self.form +++ Section("")
            
            <<< ButtonRow("学生登録") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.value = ""
            }
            
            <<< ButtonRow("通知設定") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.value = ""
            }
            <<< ButtonRow("アカウント設定") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.value = ""
        }
        
        self.form +++ Section("")
            <<< ButtonRow("レビューとお問い合わせ") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.value = ""
            }
            
            <<< ButtonRow("利用規約") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.value = ""
            }
            <<< ButtonRow("Third Party Software") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.value = ""
        }
        
        
    }
    
}
