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
    
    let UserDefault = UserDefaults.standard
    
    let key = "AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UserDefault.set("", forKey: "keyword")
        self.UserDefault.set(false, forKey: "opennow")
        
        self.view.backgroundColor = UIColor.white
        
        let searchButtton = UIBarButtonItem(title: "検索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(search(sender:)))
        
        self.navigationItem.setRightBarButton(searchButtton, animated: true)
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        GMSServices.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        
        self.setup()
        
        self.navigationItem.title  = "Asoviva"
        
    }
    
    func search(sender: UIButton){
        
        let searchResultView = SearchResultViewController()
        self.navigationController?.pushViewController(searchResultView, animated: true)
        
    }
    
    func setup() {
        self.form +++ Section("お店検索")
            
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
                    self.UserDefault.set(row.value ?? String(), forKey: "keyword")
            }
            
            <<< CheckRow("opennow"){
                $0.title = "開店中"
                
                }.onChange(){row in
                    self.UserDefault.set(row.value ?? Bool(), forKey: "opennow")
            }
            
            <<< SliderRow() {
                $0.title = "値段の上限"
                $0.minimumValue = 0
                $0.maximumValue = 10000
                $0.value = 1000
                }.onChange(){row in
                    self.UserDefault.set(row.value ?? Float(), forKey: "maxprice")
            }
            
            <<< SliderRow() {
                $0.title = "評価の下限"
                $0.minimumValue = 1
                $0.maximumValue = 5
                $0.value = 1
                }.onChange(){row in
                    self.UserDefault.set(row.value ?? Float(), forKey: "minrate")
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
        
        viewController.autocompleteFilter?.country = "Japan"
        UserDefault.set(place.coordinate.latitude, forKey: "searchlat")
        UserDefault.set(place.coordinate.longitude, forKey: "searchlng")
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



