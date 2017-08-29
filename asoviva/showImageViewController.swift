//
//  showImageViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/23.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class showImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let userDefaults = UserDefaults.standard
    var collectionView : UICollectionView!
    var params:[String:Any] = [:]
    var images:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        params["place_id"] = userDefaults.string(forKey: "place_id")
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:100, height:100)
        
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16)
        
        layout.headerReferenceSize = CGSize(width:100,height:30)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.register( imageCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell",for: indexPath as IndexPath) as! imageCollectionViewCell
        
        cell.backgroundColor = UIColor.orange
        cell.ImageView.image = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.black, size: CGSize(width:100,height:100))
        
        return cell
        
    }
    
    func getimage(){
        var photos: [String] = []
        /*
        Alamofire.request("https://server-tanahaya.c9users.io/api/microposts/image", method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
            
            let res = JSON(response.result.value!)
            print(res)
            res.array?.forEach({
                
                //let comment:Comment = Mapper<Comment>().map(JSON: $0.dictionaryObject!)!
                
                //photos.append(comment)
                
            })
            
            self.images = photos
            
        }
 */
    }
    
}
