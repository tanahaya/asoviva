//
//  SearchFormViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/06/03.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import GoogleMaps
import Eureka
import GooglePlaces

class SearchFormViewController: FormViewController {
    
    
    let userDefaults = UserDefaults.standard
    
    let key = "AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userDefaults.set("", forKey: "keyword")
        self.userDefaults.set(false, forKey: "opennow")
        
        self.view.backgroundColor = UIColor.white
        
        let searchButtton = UIBarButtonItem(title: "検索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(search(sender:)))
        
        self.navigationItem.setRightBarButton(searchButtton, animated: true)
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        GMSServices.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        
        self.setup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(sender: UIButton){
        print("search")
        
        let searchResultView = SearchResultViewController()
        self.navigationController?.pushViewController(searchResultView, animated: true)
        
    }
    
    func setup() {
        self.form +++ Section("お店検索")
            /*
             <<< CustomRow() {
             $0.cellSetup({ (cell, row) in
             cell.customImage.frame = CGRect(x: 20, y: 20, width:170 , height: 170)
             cell.customImage.layer.position =  CGPoint(x: self.view.frame.width / 2, y: 100)
             let nowimage = UIImage.fontAwesomeIcon(name: .mapPin, textColor: UIColor.black, size: CGSize(width:100,height:100))
             cell.customImage.image = nowimage
             
             })
             
             }
             */
            <<< LabelRow("place"){
                $0.title = "場所"
                $0.value = "現在地"
                
                }.onCellSelection(){row in
                    self.place()
                    
            }
            <<< TextRow("keyword"){
                $0.title = "キーワード"
                $0.placeholder = "キーワードで検索"
                
                }.onChange(){row in
                    print(row.value ?? String())
                    self.userDefaults.set(row.value ?? String(), forKey: "keyword")
            }
            
            <<< CheckRow("opennow"){
                $0.title = "開店中"
                
                }.onChange(){row in
                    print(row.value ?? Bool())
                    
                    self.userDefaults.set(row.value ?? Bool(), forKey: "opennow")
        }
    }
    func place(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
}
extension SearchFormViewController: GMSAutocompleteViewControllerDelegate {
    
    // オートコンプリートで場所が選択した時に呼ばれる関数
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // 名前をoutletに設定
        // name.text = place.name
        let SearchResultView:SearchResultViewController = SearchResultViewController()
        SearchResultView.lat = place.coordinate.latitude
        SearchResultView.lat = place.coordinate.longitude
        
        userDefaults.set(place.coordinate.latitude, forKey: "lat")
        userDefaults.set(place.coordinate.longitude, forKey: "lng")
        //print("Place name: \(place.name)")
        //print("Place address: \(String(describing: place.formattedAddress))")
        //print("Place attributions: \(String(describing: place.attributions))")
        let row: LabelRow? = self.form.rowBy(tag: "place")
        row?.value = place.name
        
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



