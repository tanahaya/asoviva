// SDKのインポート
import GoogleMaps
import GooglePlaces

class InputPlaceViewController: UIViewController{
    
    var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        let posX: CGFloat = self.view.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view.frame.height/2 - bHeight/2
        
        
        myButton = UIButton()
        myButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 20.0
        myButton.setTitle("ボタン(通常)", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        myButton.addTarget(self, action: #selector(nameInput(_:)), for: .touchUpInside)
        self.view.addSubview(myButton)
        
        
        GMSPlacesClient.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
        GMSServices.provideAPIKey("AIzaSyDJlAPjHOf0UirK-NomfpAlwY6U71soaNY")
    }
    
    // StoryBoardと接続。UITextに入力しようとした時のアクション。
    func nameInput(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // オートコンプリート用のViewの表示
        present(autocompleteController, animated: true, completion: nil)
    }
}

// InputPlaceViewControllerを拡張
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
