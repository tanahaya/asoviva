//
//  AppDelegate.swift
//  asoviva
//
//  Created by 田中千洋 on 2016/11/08.
//  Copyright © 2016年 田中 颯. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let UserDefault = UserDefaults.standard
    let dict = ["signup": true]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefault.set(true, forKey: "nomalopen")
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }})
        
        Realm.Configuration.defaultConfiguration = config
        
        GMSServices.provideAPIKey("AIzaSyCwcR3jfPvo1SNdLFTTOe0dZ1_PX_AZ2xU")
        
        self.UserDefault.register(defaults: dict)
        
        let first: MainViewController = MainViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = first
        
        self.window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //URLの確認なので無くてもOK
        UserDefault.set(false, forKey: "nomalopen")
        
        let urlHost : String = url.host as String!
        
        UserDefault.set(urlHost, forKey: "sharedplaceid")
        let resultVC: MainViewController =  MainViewController()
        self.window?.rootViewController = resultVC
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

