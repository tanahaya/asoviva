//
//  storedetailTableViewCell.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/05/16.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit

class storedetailTableViewCell: UITableViewCell {

    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
    
    @IBOutlet var favoritebutton: UIButton!
    @IBOutlet var storeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension storedetailTableViewCell {
    
    @IBAction func favoritebutton(_ sender: AnyObject) {
        let FavoriteView = FavoriteViewController()
        let RecommendView = RecommendViewController()
        
        print(RecommendView.locations)//内容なし
        //FavoriteView.favorites.append(RecommendView.locations[favoritebutton.tag])
        
        SCLAlertView().showInfo("お気に入り登録完了", subTitle: "をお気に入り登録しました。")
    }
}
