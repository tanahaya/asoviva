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
        
        self.navigationItem.title  = "Asoviva"
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
                
                }.onCellSelection(){row in
                    let SignupController = SignupViewController()
                    // webviewController.url = locations[sender.tag]
                    
                    self.navigationController?.pushViewController(SignupController, animated: true)
                    
        }
        
        self.form +++ Section("")
            
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "学生登録"
                })
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "通知設定"
                })
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "アカウント設定"
                })
        }
        
        
        self.form +++ Section("")
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "レビューとお問い合わせ"
                })
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "利用規約"
                })
            }
            <<< CustomButtonRow() {
                
                $0.cellSetup({ (cell, row) in
                    
                    cell.nameLabel.text = "Third Party Software"
                })
        }
        
    }
    
}
