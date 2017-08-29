//
//  imageCollectionViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/29.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell {
    
    var ImageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.contentView.addSubview(ImageView)
        
    }

}
