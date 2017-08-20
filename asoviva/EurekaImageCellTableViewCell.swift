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
    
    
    @IBOutlet var customImage: UIImageView!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    public override func setup() {
        super.setup()
        height = { return 100 }
        self.addSubview(customImage)
        let recommendImage = UIImage.fontAwesomeIcon(name: .angleRight, textColor: UIColor.black, size: CGSize(width:30,height:30))
        arrowImage.image = recommendImage
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
