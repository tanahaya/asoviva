//
//  storeTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/13.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Chameleon

class storeTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var distantLabel: UILabel!
    @IBOutlet var leftView: UIView!
    
    
    @IBOutlet var commentimage:UIImageView!
    @IBOutlet var favorimage:UIImageView!
    @IBOutlet var shareimage:UIImageView!
    
    
    @IBOutlet var commentnumber:UILabel!
    @IBOutlet var favornumber:UILabel!
    @IBOutlet var sharenumber:UILabel!
    
    override func awakeFromNib() {
        leftView.backgroundColor = UIColor.flatYellowColorDark()
        
        let Image1 = UIImage.fontAwesomeIcon(name: .commentO, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:20,height:20))
        let Image2 = UIImage.fontAwesomeIcon(name: .heartO, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:20,height:20))
        let Image3 = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: UIColor.flatGrayColorDark(), size: CGSize(width:20,height:20))
        
        commentimage.image = Image1
        favorimage.image = Image2
        shareimage.image = Image3
        
        commentnumber.textColor = UIColor.flatGrayColorDark()
        sharenumber.textColor = UIColor.flatGrayColorDark()
        favornumber.textColor = UIColor.flatGrayColorDark()
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
