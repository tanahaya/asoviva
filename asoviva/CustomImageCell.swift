//
//  CustomImageCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/03/14.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public class CustomImageCell:  Cell<Bool>, CellType {
    
    var ImageView:UIImageView!
    var pictureUrl: NSURL?
    
    
    public override func setup() {
        super.setup()
        ImageView = UIImageView(frame: CGRect(x:0,y:0,width:self.bounds.width,height: self.bounds.width))
        
    }
    
    public final class CustomRow: Row<CustomImageCell>, RowType {
        
        
        required public init(tag: String?) {
            super.init(tag: tag)
            // We set the cellProvider to load the .xib corresponding to our cell
            cellProvider = CellProvider<CustomImageCell>(nibName: "CustomImageCell")
        }
    }
    
    open override func setup() {
        height = { 100 }
        row.title = nil
        super.setup()
        selectionStyle = .none
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "checkedDay"), for: .selected)
                button.setImage(UIImage(named: "uncheckedDay"), for: .normal)
                button.adjustsImageWhenHighlighted = false
            }
        }
    }
    open override func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        
        guard let pictureUrl = row.value else { return }
        
        if let url = pictureUrl, let data = NSData(contentsOf: url as URL) {
            ImageView.image = UIImage(data: data as Data)
        } else {
            ImageView.image = UIImage(named: "placeholder")
        }
        
    }
    
    
}
