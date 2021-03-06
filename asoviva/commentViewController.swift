//
//  commentViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/06/18.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class commentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let UserDefault = UserDefaults.standard
    var tableView: UITableView!
    var params:[String:Any] = [:]
    var comments:[Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        params["place_id"] = UserDefault.string(forKey: "place_id")
        
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
        
        self.getComment()
        
        self.navigationItem.title  = "Asoviva"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getComment()
    }
    
    func gocomment(sender: UIButton){
        if self.UserDefault.bool(forKey: "signup") == false {
            print("Signup済み")
            let postcommentForm = postcommentFormViewController()
            self.navigationController?.pushViewController( postcommentForm, animated: true)
            
        }else if self.UserDefault.bool(forKey: "signup"){
            print("Signupまだ")
            SCLAlertView().showInfo("ユーザー未登録です", subTitle: "MyPageに行きましょう")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:commentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath as IndexPath) as! commentTableViewCell
        cell.titleLabel.text = comments[indexPath.row].title
        cell.writerLabel.text = comments[indexPath.row].writer
        cell.storeLabel.text = comments[indexPath.row].storename
        cell.favoriteLabel.text = "\( Double(comments[indexPath.row].recommendnumber!) / 10.0 )"
        cell.priceLabel.text = "\(comments[indexPath.row].price!)" + "円"
        cell.timeLabel.text = "\(comments[indexPath.row].time!)" + "時間"
        cell.commentcontent.text = comments[indexPath.row].content
        
        let str = comments[indexPath.row].date
        let currentIndex = str.index(str.endIndex, offsetBy: -8)
        cell.dateLabel.text = str.substring(to: currentIndex)
        
        let dataDecoded1 : Data = Data(base64Encoded: comments[indexPath.row].photo1, options: .ignoreUnknownCharacters)!
        let decodedimage1 = UIImage(data: dataDecoded1)
        cell.image1.image = decodedimage1
        
        let dataDecoded2 : Data = Data(base64Encoded: comments[indexPath.row].photo2, options: .ignoreUnknownCharacters)!
        let decodedimage2 = UIImage(data: dataDecoded2)
        cell.image2.image = decodedimage2
        
        let dataDecoded3 : Data = Data(base64Encoded: comments[indexPath.row].photo3, options: .ignoreUnknownCharacters)!
        let decodedimage3 = UIImage(data: dataDecoded3)
        cell.image3.image = decodedimage3
        
        let dataDecoded4 : Data = Data(base64Encoded: comments[indexPath.row].photo4, options: .ignoreUnknownCharacters)!
        let decodedimage4 = UIImage(data: dataDecoded4)
        cell.image4.image = decodedimage4
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 270
        
    }
    
    func getComment(){
        var comments: [Comment] = []
        Alamofire.request("https://server-tanahaya.c9users.io/api/showcomment", method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
            
            let res = JSON(response.result.value!)
            
            res.array?.forEach({
                let comment:Comment = Mapper<Comment>().map(JSON: $0.dictionaryObject!)!
                
                comments.append(comment)
                
            })
            
            self.comments = comments
            self.tableView.reloadData()
            
        }
    }
    
}
