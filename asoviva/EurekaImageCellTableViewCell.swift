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
    
    
    @IBOutlet weak var customImage: UIImageView!
    
    public override func setup() {
        super.setup()
        height = { return 100 }
    }
    
    public override func update() {
        super.update()
        backgroundColor = .white
    }
}
public final class CustomRow: Row<EurekaImageCellTableViewCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        // We set the cellProvider to load the .xib corresponding to our cell
        cellProvider = CellProvider<EurekaImageCellTableViewCell>(nibName: "EurekaImageCellTableViewCell")
    }
}
