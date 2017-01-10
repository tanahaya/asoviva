//
//  searchViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/08.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit


class SearchViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let posX: CGFloat = self.view.bounds.width/2 - 100
        let posY: CGFloat = self.view.bounds.height/2 - 25
        
        let label: UILabel = UILabel(frame: CGRect(x:posX, y: posY, width: 200, height: 50))
        
        label.backgroundColor = UIColor.orange
        label.text = "只今別のところを工事中"
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        self.view.backgroundColor = UIColor.white
    }

}
