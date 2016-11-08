//
//  MainViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/08.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit
import Foundation
import FontAwesome
class MainViewController: UITabBarController {

    var nowView: nowViewController!
    var searchView: searchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        nowView = nowViewController()
        searchView = searchViewController()
        
        let nowimage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:50,height:50))
        let searchimage = UIImage.fontAwesomeIcon(name: .search, textColor: UIColor.black, size: CGSize(width:50,height:50))
        nowView.tabBarItem = UITabBarItem(title: "現在地", image: nowimage, selectedImage:nowimage)
        searchView.tabBarItem = UITabBarItem(title: "探す", image: nowimage, selectedImage:nowimage)

        let nowNavigationController = UINavigationController(rootViewController: nowView)
        let searchNavigationController = UINavigationController(rootViewController: searchView)
        self.setViewControllers([nowNavigationController,searchNavigationController], animated: false)
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
