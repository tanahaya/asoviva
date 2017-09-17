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
    
    let userDefault = UserDefaults.standard
    var array:Array! = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let maincolor = UIColor.flatYellowColorDark()
        UINavigationBar.appearance().tintColor = ContrastColorOf( maincolor!, returnFlat: true)
        UINavigationBar.appearance().barTintColor = maincolor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : ContrastColorOf( maincolor!, returnFlat: true)]
        
        self.tabBar.tintColor = maincolor
        
        let SearchView:SearchFormViewController = SearchFormViewController()
        let SharedView:sharedViewController = sharedViewController()
        let RecommendView:RecommendViewController = RecommendViewController()
        let FavoriteView:FavoriteViewController = FavoriteViewController()
        let SchoolTimelineView:schoolTimelineViewController = schoolTimelineViewController()
        let MyPageView:MyPageViewController = MyPageViewController()
        
        let RecommendImage = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let SearchImage = UIImage.fontAwesomeIcon(name: .search, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let FavorImage = UIImage.fontAwesomeIcon(name: .starO, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let SchoolImage = UIImage.fontAwesomeIcon(name: .graduationCap, textColor: UIColor.black, size: CGSize(width:40,height:40))
        let UserImage = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.black, size: CGSize(width:40,height:40))
        
        RecommendView.tabBarItem = UITabBarItem(title: "おすすめ", image: RecommendImage, selectedImage: RecommendImage)
        SharedView.tabBarItem = UITabBarItem(title: "おすすめ", image: RecommendImage, selectedImage: RecommendImage)
        SearchView.tabBarItem = UITabBarItem(title: "探す", image: SearchImage, selectedImage: SearchImage)
        FavoriteView.tabBarItem = UITabBarItem(title: "お気に入り", image: FavorImage, selectedImage: FavorImage)
        SchoolTimelineView.tabBarItem = UITabBarItem(title: "スクール", image: SchoolImage, selectedImage: SchoolImage)
        MyPageView.tabBarItem = UITabBarItem(title: "MyPage", image: UserImage, selectedImage: UserImage)
        
        let recommendNavi :UIViewController = UINavigationController(rootViewController: RecommendView)
        let sharedNavi: UIViewController = UINavigationController(rootViewController: SharedView)
        let searchNavi :UIViewController = UINavigationController(rootViewController: SearchView)
        let favorNavi :UIViewController = UINavigationController(rootViewController: FavoriteView)
        let schoolNavi :UIViewController = UINavigationController(rootViewController: SchoolTimelineView)
        let mypageNavi :UIViewController = UINavigationController(rootViewController: MyPageView)
        
        if userDefault.bool(forKey: "nomalopen"){
            self.array.append(recommendNavi)
            self.array.append(searchNavi)
            self.array.append(favorNavi)
            self.array.append(schoolNavi)
            self.array.append(mypageNavi)
        }else{
            self.array.append(sharedNavi)
            self.array.append(searchNavi)
            self.array.append(favorNavi)
            self.array.append(schoolNavi)
            self.array.append(mypageNavi)
        }
        //self.setViewControllers([ recommendNavi, searchNavi,favorNavi, schoolNavi, mypageNavi], animated: false)
        self.setViewControllers( self.array as? [UIViewController], animated: false)
    }
    
}
