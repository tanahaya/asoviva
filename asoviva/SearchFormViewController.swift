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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        GMSServices.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        
        self.setup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                $0.title = "場所を決める"
                }.onCellSelection(){row in
                    self.place()
                    
        }
        
        
    }
    func place(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
}
extension InputPlaceViewController: GMSAutocompleteViewControllerDelegate {
    
    
    
    // オートコンプリートで場所が選択した時に呼ばれる関数
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        
        
        // 名前をoutletに設定
        // name.text = place.name
        print(place)
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
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



