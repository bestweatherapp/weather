//
//  SearchCityViewController.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 11.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchCityTextfield: UITextField!
    
    @IBAction func textFieldChanges(_ sender: UITextField) {
        suitableCities = [String]()
        suitableCitiesTableView.reloadData()
        SuitableCitiesRequest(inputText: sender.text!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        suitableCitiesTableView.reloadData()
    }
    
    var suitableCities = [String]()
    func SuitableCitiesRequest(inputText: String) {
        let input = inputText.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(input)&types=(cities)&language=en&key=AIzaSyDCBBOmhf9mpqKW0T-2d3zaCdB-LpJmKTc")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else {
                print("returned error")
                return
            }
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String : Any] else {
                print("Not containing JSON")
                return
            }
            
            //Reading
            if let predictions = json["predictions"] as? [AnyObject] {
                for i in 0..<predictions.count {
                    
                    if let pred = predictions[i] as? [String : AnyObject] {
                        if let description = pred["description"] as? String {
                                self.suitableCities.append(description)
                        }
                    }
                    
                }
            }
            
            DispatchQueue.main.async {
                self.suitableCitiesTableView.reloadData()
            }
            
        }
        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return suitableCities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = suitableCities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cities?.append(self.suitableCities[indexPath.row])
        dismiss(animated: true, completion: nil)
    
    }
    
    @IBOutlet weak var suitableCitiesTableView: UITableView!
    
    @IBAction func closeSearchCityVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suitableCitiesTableView.delegate = self
        suitableCitiesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
