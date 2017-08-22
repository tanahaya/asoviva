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
import Chameleon

class MainViewController: UITabBarController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let maincolor = UIColor.flatYellowColorDark()
        //ナビゲーションアイテムの色を変更
        UINavigationBar.appearance().tintColor = ContrastColorOf( maincolor!, returnFlat: true)
        //ナビゲーションバーの背景を変更
        UINavigationBar.appearance().barTintColor = maincolor
        //ナビゲーションのタイトル文字列の色を変更
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : ContrastColorOf( maincolor!, returnFlat: true)]
        
        self.tabBar.tintColor = maincolor
        
        let SearchView:SearchFormViewController = SearchFormViewController()
        let RecommendView:RecommendViewController = RecommendViewController()
        let FavoriteView:FavoriteViewController = FavoriteViewController()
        let MyPageView:MyPageViewController = MyPageViewController()
        
        let RecommendImage = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let SearchImage = UIImage.fontAwesomeIcon(name: .search, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let FavorImage = UIImage.fontAwesomeIcon(name: .starO, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let userImage = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.black, size: CGSize(width:40,height:40))
        
        RecommendView.tabBarItem = UITabBarItem(title: "おすすめ", image: RecommendImage, selectedImage: RecommendImage)
        SearchView.tabBarItem = UITabBarItem(title: "探す", image: SearchImage, selectedImage: SearchImage)
        FavoriteView.tabBarItem = UITabBarItem(title: "お気に入り", image: FavorImage, selectedImage: FavorImage)
        MyPageView.tabBarItem = UITabBarItem(title: "MyPage", image: userImage, selectedImage: userImage)
        
        let recommendNavi :UIViewController = UINavigationController(rootViewController: RecommendView)
        let searchNavi :UIViewController = UINavigationController(rootViewController: SearchView)
        let favorNavi :UIViewController = UINavigationController(rootViewController: FavoriteView)
        let mypageNavi :UIViewController = UINavigationController(rootViewController: MyPageView)
        
        
        self.setViewControllers([recommendNavi,searchNavi,favorNavi,mypageNavi ], animated: false)
    }
    
}
