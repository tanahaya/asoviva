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
        let nib = UINib(nibName: "TitleCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "TitleCell")
        
        self.view.addSubview(tableView!)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /// MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowInSection = sections[section].extended ? sections[section].details.count + 1 : 1
        
        return rowInSection
    }
    
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let titleCellId = "TitleCell"
        let detailsCellId = "DetailsCell"
        var cellId:String = ""
        
        if indexPath.row == 0 {
            cellId = titleCellId
        }else{
            cellId = detailsCellId
        }
 
        //var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        var cell:storeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath as IndexPath) as! storeTableViewCell
        // cell.nameLabel.text = "hello"
        /*
        if nil == cell {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        */
        if indexPath.row == 0 {
            //cell?.textLabel?.text = sections[indexPath.section].title
            // cell.nameLabel.text = sections[indexPath.section].title

        }else {
            
            // cell?.textLabel?.text = "detail" + String(indexPath.row)
            // cell.nameLabel.text = "detail" + String(indexPath.row)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(80)
    }
    
    
    /// MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if 0 == indexPath.row {
            // switching open or close
            sections[indexPath.section].extended = !sections[indexPath.section].extended
            
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
        details = []
        details.append("details1")
        sections.append((title: "SECTION1", details: details, extended: false)) // close
        
        
        details = []
        details.append("details1")
        details.append("details2")
        sections.append((title: "SECTION2", details: details, extended: true)) // open
        
        details = []
        details.append("details1")
        details.append("details2")
        details.append("details3")
        sections.append((title: "SECTION3", details: details, extended: true)) // open
        
        details = []
        details.append("details1")
        details.append("details2")
        details.append("details3")
        details.append("details4")
        sections.append((title: "SECTION4", details: details, extended: false)) // close
        
        for i in 5...20 {
            details = []
            details.append("details1")
            details.append("details2")
            sections.append((title: "SECTION\(i)", details: details, extended: false))
        }
        
    }


}
