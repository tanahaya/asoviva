//
//  socialViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/06/10.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

import UIKit
import Social

class socialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        var tweetButton: UIButton = UIButton()
        var facebookButton: UIButton = UIButton()
        
        tweetButton.setTitle("Twitter", for: .normal)
        tweetButton.frame = CGRect(x:0,y: 0,width: 300,height: 50)
        tweetButton.setTitleColor(UIColor.white, for: .normal)
        tweetButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        tweetButton.layer.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 30)
        tweetButton.addTarget(self, action: #selector(onClickTweetButton), for:.touchUpInside)
        
        facebookButton.setTitle("Facebook", for: .normal)
        facebookButton.frame = CGRect(x:0,y: 0,width: 300,height: 50)
        facebookButton.setTitleColor(UIColor.white, for: .normal)
        facebookButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        facebookButton.layer.position = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY + 30)
        facebookButton.addTarget(self, action: #selector(onClickFacebookButton), for:.touchUpInside)
        
        self.view.addSubview(tweetButton)
        self.view.addSubview(facebookButton)
        
    }
    
    func onClickTweetButton(sender: UIButton) {
        
        let text = "twitter share text"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(text)
        
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    func onClickFacebookButton(sender: UIButton) {
        
        let text = "facebook share text"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(text)
        
        self.present(composeViewController, animated: true, completion: nil)
    }
    
}
