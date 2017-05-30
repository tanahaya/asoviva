// SDKのインポート
import GoogleMaps

class InputPlaceViewController: UIViewController{
    // UITextのoutlet。
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // StoryBoardと接続。UITextに入力しようとした時のアクション。
    @IBAction func nameInput(_ sender: UITextField) {
        
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
        name.text = place.name
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
