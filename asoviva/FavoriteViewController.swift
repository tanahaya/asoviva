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
        //tableView.register(storeTableViewCell.self, forCellReuseIdentifier: "storeTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "storeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "storeTableViewCell")
        let detailnib = UINib(nibName: "storedetailTableViewCell", bundle: nil)
        tableView.register(detailnib, forCellReuseIdentifier: "storedetailTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.view.addSubview(storeTableView)
        
        
        self.navigationItem.title  = "Asoviva"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        favorites = favorite.loadAll()
        
        storeTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowInSection = favorites[section].extended ? 2 : 1
        
        return rowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nowfavorite = favorites[indexPath.section]
        
        
        let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
        cell.nameLabel.text = nowfavorite.storename
        
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 80
        }else {
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if 0 == indexPath.row {
            
            try! realm.write {
                
                favorites[indexPath.section].extended = !favorites[indexPath.section].extended
                
                realm.add(favorites, update: true)
                // タイトルはそのままで値段のプロパティだけを更新することができます。
            }
            
            if !favorites[indexPath.section].extended {
                self.toContract(tableView, indexPath: indexPath)
            }else{
                self.toExpand(tableView, indexPath: indexPath)
            }
            
        }else{ // ADD:
            
        }
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func toContract(_ tableView: UITableView, indexPath: IndexPath) {
        
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(row: 1 , section:indexPath.section))
        
        
        tableView.deleteRows(at: indexPaths,
                             with: UITableViewRowAnimation.fade)
    }
    
    fileprivate func toExpand(_ tableView: UITableView, indexPath: IndexPath) {
        
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(row: 1, section:indexPath.section))
        
        
        tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        
        // scroll to the selected cell.
        tableView.scrollToRow(at: IndexPath(row:indexPath.row, section:indexPath.section),
                              at: UITableViewScrollPosition.top, animated: true)
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
