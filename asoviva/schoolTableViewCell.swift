//
//  schoolTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/09/14.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka

public class schoolTableViewCell: Cell<Bool>, CellType{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var schoolLabel: UILabel!
    
    public override func setup() {
        super.setup()
        height = { return 44 }
        nameLabel.text = "学校"
        schoolLabel.text = "school"
        //schoolLabel.textColor = UIColor.flatGray()
        
    }
    
    public override func update() {
        super.update()
        backgroundColor = .white
    }
}

public final class schoolButtonRow: Row<schoolTableViewCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<schoolTableViewCell>(nibName: "schoolTableViewCell")
    }
}


