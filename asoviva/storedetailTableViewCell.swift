//
//  storedetailTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/16.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class storedetailTableViewCell: UITableViewCell {

    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var distantLabel: UILabel!
    
    
    @IBOutlet var storeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
