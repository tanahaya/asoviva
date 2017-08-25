//
//  startViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/25.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Chameleon

class startViewController: UIViewController {
    
    var imageView: UIImageView!
    var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.flatYellowColorDark()
        
        let iWidth: CGFloat = 250
        let iHeight: CGFloat = 250
        let posX: CGFloat = (self.view.bounds.width - iWidth)/2
        let posY: CGFloat = (self.view.bounds.height - iHeight)/2 - 100
        
        imageView = UIImageView(frame: CGRect(x: posX, y: posY, width: iWidth, height: iHeight))
        let image: UIImage = UIImage(named: "アイコン.jpg")!
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50.0
        self.view.addSubview(imageView)
        
        logoView = UIImageView(frame: CGRect(x: posX, y: posY + 400, width: 250, height: 65))
        let logo: UIImage = UIImage(named:"asoviva.png")!
        logoView.image = logo
        self.view.addSubview(logoView)
        
    }
    

}
