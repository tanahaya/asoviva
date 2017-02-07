//
//  DetailViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/02/07.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
