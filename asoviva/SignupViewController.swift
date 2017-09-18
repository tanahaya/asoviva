//
//  SignupViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/20.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import GoogleMaps
import GooglePlaces

class SignupViewController: FormViewController {
    
    let UserDefault = UserDefaults.standard
    
    var params: [String: Any] = ["username": "","email": "","school": "","password": ""]
    var add:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.navigationItem.title  = "Asoviva"
        
        GMSPlacesClient.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        GMSServices.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        
    }
    
    
    func setup() {
        
        form +++ Section("ユーザー情報")
            <<< TextRow("ユーザー名"){ row in
                row.title = "ユーザー名"
                row.placeholder = "username"
                }.onChange(){row in
                    self.params["username"] = row.value ?? String()
            }
            <<< schoolButtonRow("school"){ row in
                
                
                }.onCellSelection(){ row in
                    self.place()
            }
            
            <<< EmailRow("メールアドレス"){ row in
                row.title = "メールアドレス"
                row.placeholder = "email"
                }.onChange(){row in
                    self.params["email"] = row.value ?? String()
            }
            
            <<< PasswordRow("パスワード"){ row in
                row.title = "パスワード"
                row.placeholder = "password"
                
                }.onChange(){row in
                    self.params["password"] = row.value ?? String()
        }
        form +++ Section("ユーザー情報")
            <<< ButtonRow("登録"){ row in
                row.title = "登録"
                
                }.onCellSelection(){row in
                    
                    Alamofire.request("https://server-tanahaya.c9users.io/api/signup" , method: .post, parameters: self.params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                        
                        print(response.result.value!)
                        self.add = response.result.value as! [String : Any]
                        self.params["usertoken"] = self.add["usertoken"]
                        
                        self.UserDefault.set( self.params, forKey: "userinformation")
                        
                    }
                    
                    if self.UserDefault.bool(forKey: "signup") {
                        self.UserDefault.set(false, forKey: "signup")
                        print("初回起動")
                    }
                    
                    SCLAlertView().showInfo("ユーザー登録完了", subTitle: "")
                    
                    let MyPageController = MyPageViewController()
                    self.navigationController?.pushViewController(MyPageController, animated: true)
        }
        
    }
    
    func place(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
}

extension SignupViewController: GMSAutocompleteViewControllerDelegate {
    
    // オートコンプリートで場所が選択した時に呼ばれる関数
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        viewController.autocompleteFilter?.country = "Japan"
        
        UserDefault.set(place.name, forKey: "school")
        let row: schoolButtonRow? = self.form.rowBy(tag: "school")
        row?.cell.schoolLabel.text = place.name
        if place.name.characters.count > 19 {
            row?.cell.schoolLabel.font = UIFont.systemFont(ofSize: 13)
        }else if place.name.characters.count > 14 {
            row?.cell.schoolLabel.font = UIFont.systemFont(ofSize: 15)
        }else{
            row?.cell.schoolLabel.font = UIFont.systemFont(ofSize: 17)
        }
        row?.cell.schoolLabel.textColor = UIColor.black
        self.params["school"] = place.placeID
        self.UserDefault.set( place.placeID, forKey: "school")
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
