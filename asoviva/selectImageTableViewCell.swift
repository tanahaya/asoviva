//
//  selectImageTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/27.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka

public class selectImageTableViewCell: Cell<Bool>, CellType{
    
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var selectLabel: UILabel!
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    
    public override func setup() {
        super.setup()
        height = { return 70 }
        
    }
    
    public override func update() {
        super.update()
        backgroundColor = .white
    }
}
public final class CustomImageRow: Row<selectImageTableViewCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<selectImageTableViewCell>(nibName: "selectImageTableViewCell")
    }
}

