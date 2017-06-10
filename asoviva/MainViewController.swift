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

class MainViewController: UITabBarController{
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchView:SearchFormViewController = SearchFormViewController()
        let recommendView:RecommendViewController = RecommendViewController()
        let FavoriteView:FavoriteViewController = FavoriteViewController()
        let MyPageView:MyPageViewController = MyPageViewController()
        
        let recommendImage = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let searchImage = UIImage.fontAwesomeIcon(name: .search, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let FavorImage = UIImage.fontAwesomeIcon(name: .starO, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let userImage = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.black, size: CGSize(width:40,height:40))
        
        recommendView.tabBarItem = UITabBarItem(title: "おすすめ", image: recommendImage, selectedImage: recommendImage)
        searchView.tabBarItem = UITabBarItem(title: "探す", image: searchImage, selectedImage: searchImage)
        FavoriteView.tabBarItem = UITabBarItem(title: "お気に入り", image: FavorImage, selectedImage: FavorImage)
        MyPageView.tabBarItem = UITabBarItem(title: "MyPage", image: userImage, selectedImage: userImage)
        
        let recommendNavi :UIViewController = UINavigationController(rootViewController: recommendView)
        let searchNavi :UIViewController = UINavigationController(rootViewController: searchView)
        let favorNavi :UIViewController = UINavigationController(rootViewController: FavoriteView)
        let mypageNavi :UIViewController = UINavigationController(rootViewController: MyPageView)
        
        self.setViewControllers([recommendNavi,searchNavi,favorNavi,mypageNavi ], animated: false)
    }

}
