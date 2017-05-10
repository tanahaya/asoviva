//
//  EurekaImageCellTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/09.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka

public class EurekaImageCellTableViewCell: Cell<Bool>, CellType{
    
    
    var customImage: UIImageView!
    
    public override func setup() {
        super.setup()
        height = { return 100 }
        customImage.frame = CGRect(x: 20, y: 20, width:self.bounds.width , height: self.bounds.height)
        self.addSubview(customImage)
    }
    
    public override func update() {
        super.update()
        backgroundColor = .white
    }
}
public final class CustomRow: Row<EurekaImageCellTableViewCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<EurekaImageCellTableViewCell>(nibName: "EurekaImageCellTableViewCell")
    }
}
