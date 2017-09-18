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

class showImageViewController: UIViewController,UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let UserDefault = UserDefaults.standard
    var collectionView : UICollectionView!
    var params:[String:Any] = [:]
    var images:[Any] = []
    
    var detailWindow:UIWindow!
    var detailScrollView:UIScrollView!
    var detailPageControl:UIPageControl!
    var closeButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.getimage()
        
        params["place_id"] = UserDefault.string(forKey: "place_id")
        
        print(params)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:100, height:100)
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16)
        layout.headerReferenceSize = CGSize(width:100,height:30)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.register( imageCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.flatSand()
        
        self.view.addSubview(collectionView)
        
        self.getimage()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
        detailWindow = UIWindow()
        detailWindow.frame = CGRect(x:0, y:0, width: 375, height: 667)
        detailWindow.layer.position = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        detailWindow.makeKey()
        detailWindow.backgroundColor = UIColor.black
        self.detailWindow.makeKeyAndVisible()
        
        let pageSize = self.images.count
        
        detailScrollView = UIScrollView(frame: self.view.frame)
        detailScrollView.showsHorizontalScrollIndicator = false
        detailScrollView.showsVerticalScrollIndicator = false
        detailScrollView.isPagingEnabled = true
        detailScrollView.delegate = self
        detailScrollView.contentSize = CGSize(width: 375 * self.images.count ,height: 0)
        
        for i in 0 ..< self.images.count {
            
            var imageView:UIImageView!
            imageView = UIImageView(frame: CGRect(x: 0 + 375 * i,y: 70,width: 375,height: 375))
            
            let str = String(describing: self.images[i])
            let dataDecoded : Data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            imageView.image = decodedimage
            
            detailScrollView.addSubview(imageView)
            
        }
        
        detailPageControl = UIPageControl(frame: CGRect(x: 120,y: 450,width: 100,height: 50))
        detailPageControl.layer.position = CGPoint(x: self.view.frame.width/2, y: 475)
        detailPageControl.numberOfPages = pageSize
        detailPageControl.currentPage = 0
        detailPageControl.isUserInteractionEnabled = false
        
        closeButton = UIButton(frame: CGRect(x:0, y:0, width:70, height:50))
        closeButton.backgroundColor = UIColor.orange
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 5.0
        closeButton.layer.position = CGPoint(x:self.detailWindow.frame.width/2, y:self.detailWindow.frame.height - 60)
        closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        detailWindow.addSubview(detailScrollView)
        detailWindow.addSubview(detailPageControl)
        detailWindow.addSubview(closeButton)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell",for: indexPath as IndexPath) as! imageCollectionViewCell
        
        cell.backgroundColor = UIColor.orange
        
        let str = String(describing: self.images[indexPath.row])
        let dataDecoded : Data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        cell.ImageView.image = decodedimage
        
        return cell
        
    }
    
    func getimage(){
        
        print("getimage")
        self.images = []
        
        Alamofire.request("https://server-tanahaya.c9users.io/api/searchplace/image", method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
            
            let res = JSON(response.result.value!)
            if res["photos"] == "nophoto"{
                print(res["photos"])
            }else{
                for i in 0 ..< res["photos"].count {
                    self.images.append(res["photos"][i])
                }
                print(self.images)
            }
            self.collectionView.reloadData()
        }
    }
    
    func hide(){
        
        detailWindow.isHidden = true
        detailScrollView.isHidden = true
        detailPageControl.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if fmod(detailScrollView.contentOffset.x, detailScrollView.frame.maxX) == 0 {
            let on:Int = Int(detailScrollView.contentOffset.x / detailScrollView.frame.maxX)
            detailPageControl.currentPage = on
        }
        
    }
    
}



