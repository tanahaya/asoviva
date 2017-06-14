//
//  storeTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/13.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class storeTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var distantLabel: UILabel!
    @IBOutlet var leftView: UIView!
    
    
    override func awakeFromNib() {
        leftView.backgroundColor = UIColor.flatYellowColorDark()
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
