//
//  storedetailTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/16.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import RealmSwift

class storedetailTableViewCell: UITableViewCell {
    
    let realm = try! Realm()
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
    
    @IBOutlet var favoritebutton: UIButton!
    @IBOutlet var storeImage: UIImageView!
    var UserDafault:UserDefaults = UserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension storedetailTableViewCell {
    
    
    @IBAction func favoritebutton(_ sender: AnyObject) {
        
    }
}
