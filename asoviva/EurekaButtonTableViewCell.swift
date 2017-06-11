//
//  EurekaButtonTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/06/11.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka

public class EurekaButtonTableViewCell: Cell<Bool>, CellType{
    
    
    @IBOutlet var customImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    public override func setup() {
        super.setup()
        height = { return 44 }
        
        let recommendImage = UIImage.fontAwesomeIcon(name: .angleRight, textColor: UIColor.black, size: CGSize(width:30,height:30))
        customImage.image = recommendImage
        self.addSubview(customImage)
    }
    
    public override func update() {
        super.update()
        backgroundColor = .white
    }
}
public final class CustomButtonRow: Row<EurekaButtonTableViewCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<EurekaButtonTableViewCell>(nibName: "EurekaButtonTableViewCell")
    }
}

