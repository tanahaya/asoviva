//
//  storedetailTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/16.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import RealmSwift
import FontAwesome

class storedetailTableViewCell: UITableViewCell {
    
    let realm = try! Realm()
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
    @IBOutlet var buttom: UIView!
    
    @IBOutlet var favoritebutton: UIButton!
    @IBOutlet var sharebutton: UIButton!
    @IBOutlet var webbutton: UIButton!
    @IBOutlet var routebutton: UIButton!
    @IBOutlet var commentbutton: UIButton!
    @IBOutlet var phonebutton: UIButton!
    @IBOutlet var storeImage: UIImageView!
    
    @IBOutlet var commentimage:UIImageView!
    @IBOutlet var favorimage:UIImageView!
    @IBOutlet var shareimage:UIImageView!
    
    override func awakeFromNib() {
        
        let Image1 = UIImage.fontAwesomeIcon(name: .commentO, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:20,height:20))
        let Image2 = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:20,height:20))
        let Image3 = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:20,height:20))
        
        commentimage.image = Image1
        favorimage.image = Image2
        shareimage.image = Image3
        
        favoritebutton.setTitleColor(UIColor.flatGrayColorDark(), for: .normal)
        sharebutton.setTitleColor(UIColor.flatGrayColorDark(), for: .normal)
        commentbutton.setTitleColor(UIColor.flatGrayColorDark(), for: .normal)
        
        super.awakeFromNib()
        // Initialization code
    }

}
extension storedetailTableViewCell {
    
    @IBAction func favoritebutton(_ sender: AnyObject) {
        
    }
    @IBAction func webButton(_ sender: AnyObject) {
        
    }
    @IBAction func routebutton(_ sender: AnyObject) {
        
        let routeviewController = RouteViewController()
        routeviewController.navigationController?.pushViewController( routeviewController, animated: true)
    }
    @IBAction func phonebutton(_ sender: AnyObject) {
        
    }

}
