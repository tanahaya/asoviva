//
//  storeTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/13.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Chameleon

class storeTableViewCell: UITableViewCell{
    
    @IBOutlet var backview: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    
    @IBOutlet var pointimage:UIImageView!
    @IBOutlet var priceimage:UIImageView!
    @IBOutlet var commentimage:UIImageView!
    @IBOutlet var distanceimage:UIImageView!
    
    
    @IBOutlet var point:UILabel!
    @IBOutlet var price:UILabel!
    @IBOutlet var comment:UILabel!
    @IBOutlet var distance:UILabel!
    
    
    override func awakeFromNib() {
        
        let Image1 = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:25,height:25))
        let Image2 = UIImage.fontAwesomeIcon(name: .jpy, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:25,height:25))
        let Image3 = UIImage.fontAwesomeIcon(name: .commentingO, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:25,height:25))
        let Image4 = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:25,height:25))
        
        pointimage.image = Image1
        priceimage.image = Image2
        commentimage.image = Image3
        distanceimage.image = Image4
        
        //backview.backgroundColor = UIColor.flatWhite()
        nameLabel.textColor = UIColor.flatBlack()
        tagLabel.textColor = UIColor.flatGray()
        
        pointLabel.textColor = UIColor.flatGrayColorDark()
        priceLabel.textColor = UIColor.flatGrayColorDark()
        distanceLabel.textColor = UIColor.flatGrayColorDark()
        commentLabel.textColor = UIColor.flatGrayColorDark()
        
        pointLabel.textAlignment = NSTextAlignment.right
        priceLabel.textAlignment = NSTextAlignment.right
        commentLabel.textAlignment = NSTextAlignment.right
        distanceLabel.textAlignment = NSTextAlignment.right
        
        point.isHidden = true
        price.isHidden = true
        comment.isHidden = true
        distance.isHidden = true
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
