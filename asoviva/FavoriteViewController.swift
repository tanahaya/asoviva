//
//  FavoriteViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/09.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    let userDefaults = UserDefaults.standard
    var favorites:[favorite] = []
    
    let realm = try! Realm()
    var sendernumber:Int = 0
    
    lazy var storeTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0,  width: self.view.frame.width, height: 667))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "storeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "storeTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         try! realm.write {
         realm.deleteAll()
         }
        */
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.view.addSubview(storeTableView)
        
        self.navigationItem.title  = "Asoviva"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        favorites = favorite.loadAll()
        
        storeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nowfavorite = favorites[indexPath.row]
        
        
        let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
        cell.nameLabel.text = nowfavorite.storename
        
        if nowfavorite.price == 0 {
            cell.priceLabel.text = "--円"
        }else {
            cell.priceLabel.text = " \(nowfavorite.price)" + "円"
        }
        if nowfavorite.recommendnumber == 0 {
            cell.favoriteLabel.text = "--点"
        }else {
            cell.favoriteLabel.text = "\( Double(nowfavorite.recommendnumber) / 10.0 )" + "点"
        }
        
        
        cell.commentLabel.text = "\(nowfavorite.commentnumber)" + "つ"
        if indexPath.row == 0{
            cell.photoLabel.text = "4枚"
            cell.distanceLabel.text = "8分"
        }else {
            cell.photoLabel.text = "0枚"
            cell.distanceLabel.text = "\(arc4random_uniform(10) + 7 )" + "分"
        }
        
        if nowfavorite.storename.characters.count > 24 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 10)
        }else if nowfavorite.storename.characters.count > 19 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 12)
        }else if nowfavorite.storename.characters.count > 14 {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
        }else  {
            cell.nameLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        if nowfavorite.photo1 == nil{
            
            cell.storeimage1.image = UIImage(named:"nophoto.png")
            cell.storeimage2.image = UIImage(named:"nophoto.png")
            cell.storeimage3.image = UIImage(named:"nophoto.png")
            cell.storeimage4.image = UIImage(named:"nophoto.png")
            
        }else {
            let dataDecoded1 : Data = Data(base64Encoded: nowfavorite.photo1!, options: .ignoreUnknownCharacters)!
            let decodedimage1 = UIImage(data: dataDecoded1)
            cell.storeimage1.image = decodedimage1
            
            let dataDecoded2 : Data = Data(base64Encoded: nowfavorite.photo2!, options: .ignoreUnknownCharacters)!
            let decodedimage2 = UIImage(data: dataDecoded2)
            cell.storeimage2.image = decodedimage2
            
            let dataDecoded3 : Data = Data(base64Encoded: nowfavorite.photo3!, options: .ignoreUnknownCharacters)!
            let decodedimage3 = UIImage(data: dataDecoded3)
            cell.storeimage3.image = decodedimage3
            
            let dataDecoded4 : Data = Data(base64Encoded: nowfavorite.photo4!, options: .ignoreUnknownCharacters)!
            let decodedimage4 = UIImage(data: dataDecoded4)
            cell.storeimage4.image = decodedimage4
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func cancel(sender:UIButton) {
        sendernumber = sender.tag
        let alertView = SCLAlertView()
        alertView.addButton("お気に入りを解除する", target:self, selector:#selector(deleterealm))
        alertView.showSuccess("Button View", subTitle: "This alert view has buttons")
    }
    
    func deleterealm() {
        let item = self.favorites[sendernumber]
        
        try! realm.write {
            realm.delete(item)
        }
        self.favorites.remove(at: sendernumber)
        //storeTableView.deleteRowsAtIndexPaths([sender.tag], withRowAnimation: .Fade)
        self.storeTableView.reloadData()
    }
}
