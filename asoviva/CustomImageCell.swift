//
//  CustomImageCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/03/14.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka

public class CustomImageCell:  Cell<Bool>, CellType {
    
    var Imageview:UIImageView!
    var pictureUrl: NSURL?
    
    public override func setup() {
        super.setup()
        Imageview = UIImageView(frame: CGRect(x:0,y:0,width:self.bounds.width,height: self.bounds.width))
        
    }
    
    public final class CustomRow: Row<CustomImageCell>, RowType {
        
        
        required public init(tag: String?) {
            super.init(tag: tag)
            // We set the cellProvider to load the .xib corresponding to our cell
            cellProvider = CellProvider<CustomImageCell>(nibName: "CustomImageCell")
        }
    }
    override  func setup() {
        super.setup()
        
        // configure our profile picture imageView
        Imageview.contentMode = .scaleAspectFill
        Imageview.clipsToBounds = true
        height = { return 100 }
    }
    override  func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        
        // get the value from our row
        guard let user = row.value else { return }
        /*
         if let url = pictureUrl, let data = NSData(contentsOfURL: url) {
         userImageView.image = UIImage(data: data)
         } else {
         userImageView.image = UIImage(named: "placeholder")
         }
         */
    }
    
}
