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
        self.form +++ Section("お店検索")
            /*
             <<< CustomRow() {
             $0.cellSetup({ (cell, row) in
             cell.customImage.frame = CGRect(x: 20, y: 20, width:170 , height: 170)
             cell.customImage.layer.position =  CGPoint(x: self.view.frame.width / 2, y: 100)
             let nowimage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:100,height:100))
             cell.customImage.image = nowimage
             
             })
             
             }
             */
            <<< LabelRow("place"){
                $0.title = "場所"
                $0.value = "現在地"
                
                }.onCellSelection(){row in
                    
                    
            }
            <<< ButtonRow("Custom Cells") { (row: ButtonRow) -> () in
                row.title = row.tag
            }

            
            <<< TextRow("keyword"){
                $0.title = "キーワード"
                $0.placeholder = "キーワードで検索"
                
                }.onChange(){row in
                    print(row.value ?? String())
            }
            
            <<< CheckRow("opennow"){
                $0.title = "開店中"
                
                }.onChange(){row in
                    print(row.value ?? Bool())
        }
    }

    


}
