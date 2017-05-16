//
//  testAccordionViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/16.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class testAccordionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView?
    
    var sections: [(title: String, details: [String], extended: Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSectionsValue()
        
        tableView = UITableView(frame: view.frame)
        tableView?.delegate = self
        tableView?.dataSource = self
        let nib = UINib(nibName: "storeTableViewCell", bundle: nil)
        let detailnib = UINib(nibName: "storedetailTableViewCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "storeTableViewCell")
        tableView?.register(detailnib, forCellReuseIdentifier: "storedetailTableViewCell")
        
        self.view.addSubview(tableView!)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowInSection = sections[section].extended ? sections[section].details.count + 1 : 1
        print(rowInSection)
        return rowInSection
    }
    
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeTableViewCell", for: indexPath as IndexPath) as! storeTableViewCell
            
            cell.nameLabel.text = sections[indexPath.section].title
            
            return cell
            
        }else{
            
            let cell:storedetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storedetailTableViewCell", for: indexPath as IndexPath) as! storedetailTableViewCell
            
            cell.nameLabel.text = "detail" + String(indexPath.row)
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else {
            return 300
        }
    }
    
    
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if 0 == indexPath.row {
            // switching open or close
            sections[indexPath.section].extended = !sections[indexPath.section].extended
            print(sections[indexPath.section].extended)
            if !sections[indexPath.section].extended {
                self.toContract(tableView, indexPath: indexPath)
            }else{
                self.toExpand(tableView, indexPath: indexPath)
            }
            
        }else{ // ADD:
            let section = sections[indexPath.section]
            let title = section.title
            let detail = section.details[indexPath.row - 1]
            print("tapped: \(title) - \(detail)")
            
            
        }
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func toContract(_ tableView: UITableView, indexPath: IndexPath) {
        
        let startRow = indexPath.row + 1
        let endRow = sections[indexPath.section].details.count + 1
        
        var indexPaths: [IndexPath] = []
        for i in startRow ..< endRow {
            indexPaths.append(IndexPath(row: i , section:indexPath.section))
        }
        
        tableView.deleteRows(at: indexPaths,
                             with: UITableViewRowAnimation.fade)
    }
    
    /// open details.
    ///
    /// - Parameter tableView: self.tableView
    /// - Parameter indexPath: NSIndexPath
    fileprivate func toExpand(_ tableView: UITableView, indexPath: IndexPath) {
        let startRow = indexPath.row + 1
        let endRow = sections[indexPath.section].details.count + 1
        
        var indexPaths: [IndexPath] = []
        for i in startRow ..< endRow {
            indexPaths.append(IndexPath(row: i, section:indexPath.section))
        }
        
        tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        
        // scroll to the selected cell.
        tableView.scrollToRow(at: IndexPath(
            row:indexPath.row, section:indexPath.section),
                              at: UITableViewScrollPosition.top, animated: true)
    }
    
    
    
    fileprivate func getSectionsValue(){
        
        var details: [String]
        
        for i in 0 ..< 20 {
            details = []
            details.append("details1")
            sections.append((title: "SECTION\(i)", details: details, extended: true ))
        }
        
    }
    
    
}
