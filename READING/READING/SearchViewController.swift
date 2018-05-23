//
//  SearchViewController.swift
//  READING
//
//  Created by Maxim Reshetov on 22.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

protocol MyDelegate {
    func passSelectedCity()
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    
    let suitableCititesTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close60"), for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(CloseSearchView), for: .touchUpInside)
        return button
    }()
    
    @objc private func CloseSearchView() {
        dismiss(animated: true, completion: nil)
    }
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter the city"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = UITextBorderStyle.none
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.backgroundColor = UIColor(red: 172, green: 172, blue: 172, alpha: 80)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        suitableCities = [String]()
        suitableCititesTableView.reloadData()
        SuitableCitiesRequest(inputText: textField.text!)
    }
    
    let back: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTextField)
        view.addSubview(closeButton)
        view.addSubview(suitableCititesTableView)
        view.addSubview(back)
        suitableCititesTableView.delegate = self
        suitableCititesTableView.dataSource = self
        Layout()
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
                self.suitableCititesTableView.reloadData()
            }
        }
        task.resume()
    }
    
    func Layout() {
        searchTextField.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 25).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: back.leadingAnchor, constant: 25).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: back.trailingAnchor, constant: -25).isActive = true
        
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75).isActive = true
        back.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75).isActive = true
        back.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: back.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: back.trailingAnchor, constant: -25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        suitableCititesTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 25).isActive = true
        suitableCititesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        suitableCititesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        suitableCititesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}

