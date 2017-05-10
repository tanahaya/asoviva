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
        let recommendView:RecommendViewController = RecommendViewController()
        let FavoriteView:FavoriteViewController = FavoriteViewController()
        
        let nowImage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:50,height:50))
        let searchImage = UIImage.fontAwesomeIcon(name: .search, textColor: UIColor.black, size: CGSize(width:50,height:50))
        let FavorImage = UIImage.fontAwesomeIcon(name: .starO, textColor: UIColor.black, size: CGSize(width:50,height:50))
        let recommendImage = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.black, size: CGSize(width:50,height:50))
        
        
        
        recommendView.tabBarItem = UITabBarItem(title: "おすすめ", image: recommendImage, selectedImage: recommendImage)
        homeView.tabBarItem = UITabBarItem(title: "現在地", image: nowImage, selectedImage: nowImage)
        searchView.tabBarItem = UITabBarItem(title: "探す", image: searchImage, selectedImage: searchImage)
        FavoriteView.tabBarItem = UITabBarItem(title: "お気に入り", image: FavorImage, selectedImage: FavorImage)
        
        
        let recommendNavigationController = UINavigationController(rootViewController: recommendView)
        let homeNavigationController = UINavigationController(rootViewController: homeView)
        let searchNavigationController = UINavigationController(rootViewController: searchView)
        let favorNavigationController = UINavigationController(rootViewController: FavoriteView)
        
        self.setViewControllers([recommendNavigationController,homeNavigationController,searchNavigationController,favorNavigationController], animated: false)
        
    }

}
