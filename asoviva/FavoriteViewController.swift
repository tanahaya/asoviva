//
//  FavoriteViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/09.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var favorites:[Location] = []
    
    lazy var favoriteTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: self.view.frame.height ,  width: self.view.frame.width, height: 230))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel?.text = favorites[indexPath.row].storename
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}
