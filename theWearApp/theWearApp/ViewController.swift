//
//  ViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! HourCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "tableViewcell", for: indexPath) as! DayCell
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "1"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8) {
            self.topStackView.frame.origin.x = -self.view.frame.width
            self.middleStackView.frame.origin.x = -self.view.frame.width
            self.bottomStackView.frame.origin.x = -self.view.frame.width
            self.detailedView.frame.origin.x = 25
        }
    }
}

class ViewController: UIViewController {
    
    private let detailedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "search"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let currentLocation: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Moscow", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
        text.attributedText = attributedText
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.isEditable = false
        text.isScrollEnabled = false
        text.isSelectable = false
        return text
    }()
   
    private let currentTemperature: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "23°", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 80), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
        text.attributedText = attributedText
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.isEditable = false
        text.isScrollEnabled = false
        text.isSelectable = false
        return text
    }()
    
    private let currentCondition: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Sunny", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 25), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
        text.attributedText = attributedText
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.isEditable = false
        text.isScrollEnabled = false
        text.isSelectable = false
        return text
    }()
    
    private let currentAdvice: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Please take your umbrella with you and also the uv index is 39960 so try to avoid shadowed places", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
        text.attributedText = attributedText
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.isEditable = false
        text.isScrollEnabled = false
        text.isSelectable = false
        return text
    }()
    
    private let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    let forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 25
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var topStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private var middleStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private func LayOut() {
        view.addSubview(detailedView)
        bottomStackView.addArrangedSubview(forecastCollectionView)
        bottomStackView.addArrangedSubview(forecastTableView)
        view.addSubview(bottomStackView)
        
        middleStackView.addArrangedSubview(currentTemperature)
        middleStackView.addArrangedSubview(currentCondition)
        middleStackView.addArrangedSubview(currentAdvice)
        view.addSubview(middleStackView)
        
        topStackView.addArrangedSubview(menuButton)
        topStackView.addArrangedSubview(currentLocation)
        topStackView.addArrangedSubview(searchButton)
        view.addSubview(topStackView)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            print("iPhone 6")
            
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
            bottomStackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
            middleStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10).isActive = true
            middleStackView.heightAnchor.constraint(equalToConstant: 190).isActive = true
            
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
            topStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            forecastCollectionView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
            forecastCollectionView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
            forecastCollectionView.bottomAnchor.constraint(equalTo: forecastTableView.topAnchor, constant: -25).isActive = true
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            forecastTableView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor).isActive = true
            forecastTableView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
            forecastTableView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
            forecastTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
            menuButton.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor).isActive = true
            menuButton.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
            menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            searchButton.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor).isActive = true
            searchButton.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
            searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            currentLocation.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
            currentLocation.widthAnchor.constraint(equalToConstant: 175).isActive = true
            currentLocation.heightAnchor.constraint(equalToConstant: 40).isActive = true
            currentLocation.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor).isActive = true
            detailedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width + 25).isActive = true
            detailedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
            detailedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
            detailedView.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
            
        case 2208:
            print("iPhone 6+")
        case 2436:
            print("iPhone X")
        default:
            return
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlue
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastCollectionView.dataSource = self
        //forecastTableView.register(DayCell.self, forCellReuseIdentifier: "tableViewcell")
        forecastCollectionView.register(HourCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        LayOut()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

