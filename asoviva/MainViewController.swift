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
import CoreLocation

class MainViewController: UITabBarController {
   
       override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchView:SearchViewController = SearchViewController()
        let homeView:HomeViewController = HomeViewController()
        
        let nowimage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:50,height:50))
        let searchimage = UIImage.fontAwesomeIcon(name: .search, textColor: UIColor.black, size: CGSize(width:50,height:50))
        
        
        
        homeView.tabBarItem = UITabBarItem(title: "現在地", image: nowimage, selectedImage: nowimage)
        searchView.tabBarItem = UITabBarItem(title: "探す", image: searchimage, selectedImage: searchimage)
        
        let homeNavigationController = UINavigationController(rootViewController: homeView)
        let searchNavigationController = UINavigationController(rootViewController: searchView)
        self.setViewControllers([homeNavigationController,searchNavigationController], animated: false)
        
    }

}
