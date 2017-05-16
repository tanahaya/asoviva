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
    
    
    lazy var storeTableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0,  width: self.view.frame.width, height: self.view.frame.width - 60))
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
        
        self.view.addSubview(storeTableView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        storeTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return favorites.count
    }
    
    /// MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowInSection = favorites[section].extended ? 2 : 1
        
        return rowInSection
    }
    
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
            
            cell.nameLabel.text = favorites[indexPath.section].storename
            cell.pointLabel.textAlignment = NSTextAlignment.left
            cell.priceLabel.textAlignment = NSTextAlignment.left
            cell.distantLabel.textAlignment = NSTextAlignment.left
            cell.numberLabel.text = "# " + String(indexPath.section + 1)
            
            return cell
            
        }else{
            
            let cell:storedetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storedetailTableViewCell", for: indexPath as IndexPath) as! storedetailTableViewCell
            
            cell.nameLabel.text = favorites[indexPath.section].storename
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else {
            return 220
        }
    }
    
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if 0 == indexPath.row {
            // switching open or close
            
            favorites[indexPath.section].extended = !favorites[indexPath.section].extended
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
        tableView.scrollToRow(at: IndexPath(
            row:indexPath.row, section:indexPath.section),
                              at: UITableViewScrollPosition.top, animated: true)
    }
}
