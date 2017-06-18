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
    @IBOutlet var upperview: UIView!
    @IBOutlet var nameunderview: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var photoLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var photoview:UIView!
    @IBOutlet var priceview:UIView!
    @IBOutlet var commentview:UIView!
    @IBOutlet var distanceview:UIView!
    @IBOutlet var phoneview:UIView!
    @IBOutlet var shareview:UIView!
    @IBOutlet var favoriteview:UIView!
    @IBOutlet var timeview:UIView!
    
    @IBOutlet var photoimage:UIImageView!
    @IBOutlet var priceimage:UIImageView!
    @IBOutlet var commentimage:UIImageView!
    @IBOutlet var distanceimage:UIImageView!
    @IBOutlet var phoneimage:UIImageView!
    @IBOutlet var shareimage:UIImageView!
    @IBOutlet var favoriteimage:UIImageView!
    @IBOutlet var timeimage:UIImageView!
    
    @IBOutlet var photoButton:UIButton!
    @IBOutlet var priceButton:UIButton!
    @IBOutlet var commentButton:UIButton!
    @IBOutlet var distanceButton:UIButton!
    @IBOutlet var phoneButton:UIButton!
    @IBOutlet var shareButton:UIButton!
    @IBOutlet var favoriteButton:UIButton!
    @IBOutlet var timeButton:UIButton!
    
    override func awakeFromNib() {
        
        let heartImage = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let yenImage = UIImage.fontAwesomeIcon(name: .jpy, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let commentImage = UIImage.fontAwesomeIcon(name: .commentingO, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let mapImage = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let cameraImage = UIImage.fontAwesomeIcon(name: .camera, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let phoneImage = UIImage.fontAwesomeIcon(name: .phone, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let shareImage = UIImage.fontAwesomeIcon(name: .shareSquareO, textColor: UIColor.white, size: CGSize(width:25,height:25))
        let clockImage = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.white, size: CGSize(width:25,height:25))
        
        photoimage.image = cameraImage
        priceimage.image = yenImage
        commentimage.image = commentImage
        distanceimage.image = mapImage
        phoneimage.image = phoneImage
        shareimage.image = shareImage
        favoriteimage.image = heartImage
        timeimage.image = clockImage
        
        //backview.backgroundColor = UIColor.flatWhite()
        nameLabel.textColor = UIColor.flatBlack()
        nameunderview.backgroundColor = UIColor.flatSkyBlue()
        
        photoLabel.textColor = UIColor.white
        priceLabel.textColor = UIColor.white
        distanceLabel.textColor = UIColor.white
        commentLabel.textColor = UIColor.white
        
        upperview.backgroundColor = UIColor.flatWhiteColorDark()
        
        phoneview.backgroundColor = UIColor.flatNavyBlue()
        priceview.backgroundColor = UIColor.flatYellow()
        commentview.backgroundColor = UIColor.flatWatermelon()
        distanceview.backgroundColor = UIColor.flatGreen()
        phoneview.backgroundColor = UIColor.flatSkyBlue()
        shareview.backgroundColor = UIColor.flatLime()
        favoriteview.backgroundColor = UIColor.flatPink()
        timeview.backgroundColor = UIColor.flatMint()
        
        photoview.layer.masksToBounds = true
        priceview.layer.masksToBounds = true
        commentview.layer.masksToBounds = true
        distanceview.layer.masksToBounds = true
        phoneview.layer.masksToBounds = true
        shareview.layer.masksToBounds = true
        favoriteview.layer.masksToBounds = true
        timeview.layer.masksToBounds = true
        
        photoview.layer.cornerRadius = 5.0
        priceview.layer.cornerRadius = 5.0
        commentview.layer.cornerRadius = 5.0
        distanceview.layer.cornerRadius = 5.0
        phoneview.layer.cornerRadius = 5.0
        shareview.layer.cornerRadius = 5.0
        favoriteview.layer.cornerRadius = 5.0
        timeview.layer.cornerRadius = 5.0
        
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
