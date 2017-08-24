//
//  commentViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/06/18.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Alamofire

class commentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userDefaults = UserDefaults.standard
    private var tableView: UITableView!
    var params:[String:Any] = ["place_id":"aaaa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getComment()
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "commentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "commentTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        let rightButton = UIBarButtonItem(title: "コメントする", style: UIBarButtonItemStyle.plain, target: self, action: #selector(gocomment(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gocomment(sender: UIButton){
        if self.userDefaults.bool(forKey: "signup") == false {
            print("Signup済み")
            let postcommentForm = postcommentFormViewController()
            self.navigationController?.pushViewController( postcommentForm, animated: true)
            
        }else if self.userDefaults.bool(forKey: "signup"){
            print("Signupまだ")
            SCLAlertView().showInfo("ユーザー登録をしてください", subTitle: "MyPageに行きましょう")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:commentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath as IndexPath) as! commentTableViewCell
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 250
    }
    func getComment(){
        
        Alamofire.request("https://server-tanahaya.c9users.io/api/showcomment", method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
            
        }
        
    }
    
}
