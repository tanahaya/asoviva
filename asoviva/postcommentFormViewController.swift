//
//  postcommentViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/22.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import SwiftyJSON
import DKImagePickerController


class postcommentFormViewController:FormViewController {
    
    let UserDefault = UserDefaults.standard
    var comment: [String: Any] = ["title": "タイトル","content": "Hello,world","time": 1,"money": 1000,"recommendnumber": 5,"place_id": ""]
    var params: [String: Any] = [:]
    var number:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //usertoken入ってない
        self.setup()
        params["usertoken"] = UserDefault.dictionary(forKey: "userinformation")?["usertoken"]
        comment["writer"] = UserDefault.dictionary(forKey: "userinformation")?["username"]
        comment["school"] = UserDefault.dictionary(forKey: "userinformation")?["school"]
        comment["place_id"] = UserDefault.string(forKey: "place_id")
        params["place_id"] = UserDefault.string(forKey: "place_id")
        params["name"] = UserDefault.string(forKey: "place_name")
        comment["name"] = UserDefault.string(forKey: "place_name")
        
        
        self.navigationItem.title  = "Asoviva"
    }
    
    func setup() {
        
        form +++ Section("ユーザー情報")
            <<< TextRow("タイトル"){ row in
                row.title = "タイトル"
                row.placeholder = "タイトルを入れて下さい"
                }.onChange(){row in
                    self.comment["title"] = row.value
            }
            <<< SliderRow() {
                $0.title = "おすすめ度"
                $0.minimumValue = 1.0
                $0.maximumValue = 5.0
                $0.value = 5.0
                }.onChange(){row in
                    self.comment["recommendnumber"] = Int(row.value!  * 10.0)
                    self.params["recommendnumber"] = Int(row.value!  * 10.0)
            }
            
            <<< SliderRow() {
                $0.title = "過ごした時間"
                $0.value = 1.0
                }.onChange(){row in
                    self.comment["time"] = Int(row.value!)
                    self.params["time"] = Int(row.value!)
            }
            
            <<< SliderRow() {
                $0.title = "値段"
                $0.minimumValue = 0
                $0.maximumValue = 10000
                $0.value = 1000
                }.onChange(){row in
                    self.comment["money"] = Int(row.value!)
                    self.params["money"] = Int(row.value!)
            }
            
            <<< TextAreaRow("口コミ本文") {
                $0.placeholder = "口コミ本文を入れて下さい"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 100)
                }.onChange(){row in
                    self.comment["content"] = row.value
        }
        
        form +++ Section("写真投稿")
            <<< CustomImageRow("image"){ row in
                
                }.onCellSelection(){row in
                    
                    let pickerController = DKImagePickerController()
                    
                    pickerController.maxSelectableCount = 4
                    pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                        // 選択された画像はassetsに入れて返却されますのでfetchして取り出すとよいでしょう
                        for asset in assets {
                            self.number = self.number + 1
                            asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                                
                                if self.number == 1 {
                                    row.0.imageView1.image = image
                                    let data1: NSData = UIImageJPEGRepresentation(image!, 0.05)! as NSData
                                    let encodeString1:String = data1.base64EncodedString(options: .lineLength64Characters)
                                    self.comment["photo1"] = encodeString1
                                    self.params["photo1"] = encodeString1
                                    self.UserDefault.set( 1, forKey: "photonumber")
                                }else if self.number == 2 {
                                    row.0.imageView2.image = image
                                    let data2: NSData = UIImageJPEGRepresentation(image!, 0.05)! as NSData
                                    let encodeString2:String = data2.base64EncodedString(options: .lineLength64Characters)
                                    self.comment["photo2"] = encodeString2
                                    self.params["photo2"] = encodeString2
                                    self.UserDefault.set( 2, forKey: "photonumber")
                                }else if self.number == 3 {
                                    row.0.imageView3.image = image
                                    let data3: NSData = UIImageJPEGRepresentation(image!, 0.05)! as NSData
                                    let encodeString3:String = data3.base64EncodedString(options: .lineLength64Characters)
                                    self.comment["photo3"] = encodeString3
                                    self.params["photo3"] = encodeString3
                                    self.UserDefault.set( 3, forKey: "photonumber")
                                }else if self.number == 4 {
                                    row.0.imageView4.image = image
                                    let data4: NSData = UIImageJPEGRepresentation(image!, 0.05)! as NSData
                                    let encodeString4:String = data4.base64EncodedString(options: .lineLength64Characters)
                                    self.comment["photo4"] = encodeString4
                                    self.params["photo4"] = encodeString4
                                    self.UserDefault.set( 4, forKey: "photonumber")
                                }
                            })
                        }
                    }
                    row.0.selectLabel.text = ""
                    self.present(pickerController, animated: true) {}
        }
        
        form +++ Section("投稿")
            <<< ButtonRow("投稿する"){ row in
                row.title = "投稿する"
                
                }.onCellSelection(){row in
                    
                    let money:Int = self.comment["money"] as! Int
                    let time:Int = self.comment["time"] as! Int
                    self.params["price"] = money / time
                    self.params["microposts"] = self.comment
                    self.params["photonumber"] = self.UserDefault.integer(forKey: "photonumber")
                    print(self.params)
                    
                    Alamofire.request("https://server-tanahaya.c9users.io/api/microposts" , method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                        // print(response.result.value!)
                        
                    }
                    SCLAlertView().showInfo("投稿登録完了", subTitle: "")
                    
                    //let Recommed = RecommendViewController()
                    //self.navigationController?.pushViewController(Recommed, animated: true)
                    
        }
    }
}
