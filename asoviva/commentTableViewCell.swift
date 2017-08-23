//
//  commentTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/19.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Chameleon

class commentTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var writerLabel: UILabel!
    @IBOutlet var favoriteLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var storeView:UIView!
    @IBOutlet var writerView:UIView!
    @IBOutlet var favoriteView:UIView!
    @IBOutlet var priceView:UIView!
    @IBOutlet var timeView:UIView!
    
    @IBOutlet var storeImageView:UIImageView!
    @IBOutlet var writerImageView:UIImageView!
    @IBOutlet var favoriteImageView:UIImageView!
    @IBOutlet var priceImageView:UIImageView!
    @IBOutlet var timeImageView:UIImageView!
    
    @IBOutlet var arrowImageView:UIImageView!
    
    @IBOutlet var storeButton:UIButton!
    
    @IBOutlet var commentcontent:UITextView!
    
    override func awakeFromNib() {
        
        let heartImage = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let clockImage = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let yenImage = UIImage.fontAwesomeIcon(name: .jpy, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let writerImage = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let storeImage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let arrowImage = UIImage.fontAwesomeIcon(name: .angleRight, textColor: UIColor.white, size: CGSize(width:25,height:25))
        
        //storeLabel.textColor = UIColor.black
        
        storeImageView.image = storeImage
        writerImageView.image = writerImage
        favoriteImageView.image = heartImage
        priceImageView.image = yenImage
        timeImageView.image = clockImage
        arrowImageView.image = arrowImage
        
        storeView.backgroundColor = UIColor.flatYellowColorDark()
        writerView.backgroundColor = UIColor.flatSkyBlue()
        favoriteView.backgroundColor = UIColor.flatPink()
        priceView.backgroundColor = UIColor.flatYellow()
        timeView.backgroundColor = UIColor.flatGreen()
        
        storeView.layer.masksToBounds = true
        writerView.layer.masksToBounds = true
        favoriteView.layer.masksToBounds = true
        priceView.layer.masksToBounds = true
        timeView.layer.masksToBounds = true
        
        storeView.layer.cornerRadius = 5.0
        writerView.layer.cornerRadius = 5.0
        favoriteView.layer.cornerRadius = 5.0
        priceView.layer.cornerRadius = 5.0
        timeView.layer.cornerRadius = 5.0
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
