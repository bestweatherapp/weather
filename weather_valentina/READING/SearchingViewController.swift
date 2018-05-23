//
//  SearchingViewController.swift
//  READING
//
//  Created by Валентина on 11.05.18.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

class SearchingViewController: UIViewController {

   var selectedCity = ""
    var AllPreferences = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }

   
    @IBOutlet weak var searchBar: UISearchBar!
    



}
extension SearchingViewController : UISearchBarDelegate
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReturnToPreferences"
        {
            var dataFromSearch : PreferencesTableViewController = (segue.destination as? PreferencesTableViewController)!
            dataFromSearch.CityFromSearch = self.selectedCity
            
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.selectedCity = searchBar.text!.replacingOccurrences(of: " ", with: "")
        var errorHasOccured = false
        let urlString2 = "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(selectedCity)&days=7"
        let url2 = URL(string: urlString2)
        let check : URL?
        check = url2
        if (check == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Invalid city", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            searchBar.text=""
            return
        }
        else{
            let task2 = URLSession.shared.dataTask(with: url2!) {[weak self] (data, response, error) in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                       as! [String : AnyObject]
                     if let _ = json["error"] {
                        errorHasOccured = true
                    }
                    DispatchQueue.main.async {
                        if errorHasOccured {
                            let alert = UIAlertController(title: "Error", message: "Invalid city", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self?.present(alert, animated: true)
                            searchBar.text=""
                            return
                        }
                        else
                        {
                            if (self?.AllPreferences.contains((self?.selectedCity)!))!
                            {
                                let alert = UIAlertController(title: "Error", message: "You have already added this city", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self?.present(alert, animated: true)
                                searchBar.text=""
                                return
                            }
                            self?.performSegue(withIdentifier: "ReturnToPreferences", sender: Any?.self)
                        }
                    }
                }
                catch let jsonError {
                    print(jsonError)
                }
        }
            task2.resume()
            
           
            
       }
        
}
}
