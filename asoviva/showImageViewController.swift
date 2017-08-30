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
    
    let userDefaults = UserDefaults.standard
    var collectionView : UICollectionView!
    var params:[String:Any] = [:]
    var images:[String] = []
    
    var detailWindow:UIWindow!
    var detailScrollView:UIScrollView!
    var detailPageControl:UIPageControl!
    var closeButton:UIButton!
    var imageView1:UIImageView!
    var imageView2:UIImageView!
    var imageView3:UIImageView!
    var imageView4:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.getimage()
        
        params["place_id"] = userDefaults.string(forKey: "place_id")
        
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
        
        let pageSize = 4
        
        detailScrollView = UIScrollView(frame: self.view.frame)
        detailScrollView.showsHorizontalScrollIndicator = false
        detailScrollView.showsVerticalScrollIndicator = false
        detailScrollView.isPagingEnabled = true
        detailScrollView.delegate = self
        detailScrollView.contentSize = CGSize(width: 1500,height: 0)
        
        imageView1 = UIImageView(frame: CGRect(x: 0,y: 70,width: 375,height: 375))
        imageView2 = UIImageView(frame: CGRect(x: 375,y: 70,width: 375,height: 375))
        imageView3 = UIImageView(frame: CGRect(x: 750,y: 70,width: 375,height: 375))
        imageView4 = UIImageView(frame: CGRect(x: 1125,y: 70,width: 375,height: 375))
        
        let dataDecoded1 : Data = Data(base64Encoded: userDefaults.string(forKey: "photo0")!, options: .ignoreUnknownCharacters)!
        let decodedimage1 = UIImage(data: dataDecoded1)
        imageView1.image = decodedimage1
        
        let dataDecoded2 : Data = Data(base64Encoded: userDefaults.string(forKey: "photo1")!, options: .ignoreUnknownCharacters)!
        let decodedimage2 = UIImage(data: dataDecoded2)
        imageView2.image = decodedimage2
        
        let dataDecoded3 : Data = Data(base64Encoded: userDefaults.string(forKey: "photo2")!, options: .ignoreUnknownCharacters)!
        let decodedimage3 = UIImage(data: dataDecoded3)
        imageView3.image = decodedimage3
        
        let dataDecoded4 : Data = Data(base64Encoded: userDefaults.string(forKey: "photo3")!, options: .ignoreUnknownCharacters)!
        let decodedimage4 = UIImage(data: dataDecoded4)
        imageView4.image = decodedimage4
        
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
        detailScrollView.addSubview(imageView1)
        detailScrollView.addSubview(imageView2)
        detailScrollView.addSubview(imageView3)
        detailScrollView.addSubview(imageView4)
        detailWindow.addSubview(detailPageControl)
        detailWindow.addSubview(closeButton)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4//images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell",for: indexPath as IndexPath) as! imageCollectionViewCell
        
        cell.backgroundColor = UIColor.orange
        
        let dataDecoded : Data = Data(base64Encoded: userDefaults.string(forKey: "photo\(indexPath.row)")!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        cell.ImageView.image = decodedimage
        
        //cell.ImageView.image = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.black, size: CGSize(width:100,height:100))
        
        return cell
        
    }
    
    func getimage(){
        
        print("getimage")
        var photos: [String] = []
        
        Alamofire.request("https://server-tanahaya.c9users.io/api/microposts/image", method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON{ response in
            
            let res = JSON(response.result.value!)
            print(res)
            
            //self.images = res.rawValue as! [String]
            
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



