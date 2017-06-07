//
//  WebPageViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/31.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class WebPageViewController: UIViewController, UIWebViewDelegate {

    var WebView: UIWebView!
    var url:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebView = UIWebView()
        WebView.delegate = self
        WebView.frame = self.view.bounds
        let url: URL = URL(string: self.url)!
        let request: NSURLRequest = NSURLRequest(url: url)
        WebView.loadRequest(request as URLRequest)
        self.view.addSubview(WebView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
    }
    
    /*
     PageがLoadされ始めた時、呼ばれる.
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
    }
}
