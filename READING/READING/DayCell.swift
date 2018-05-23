//
//  DayCell.swift
//  READING
//
//  Created by Maxim Reshetov on 21.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    let clothes: UIImageView = {
        let c = UIImageView(image: UIImage(named: "sweater"))
        c.contentMode = .scaleAspectFit
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    let day: UITextView = {
        let d = UITextView()
        d.backgroundColor = UIColor(white: 1, alpha: 0)
        d.textAlignment = .left
        d.isSelectable = false
        d.isScrollEnabled = false
        d.translatesAutoresizingMaskIntoConstraints = false
        return d
    }()
    
    let weather: UITextView = {
        let w = UITextView()
        w.backgroundColor = UIColor(white: 1, alpha: 0)
        w.textAlignment = .right
        w.isSelectable = false
        w.isScrollEnabled = false
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    private func setupLayout() {
        let dateAndTextView = UIView()
        dateAndTextView.translatesAutoresizingMaskIntoConstraints = false
        
        dateAndTextView.addSubview(day)
        
        
        let clothesView = UIView()
        clothesView.translatesAutoresizingMaskIntoConstraints = false
        
        clothesView.addSubview(clothes)
        
        let weatherView = UIView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        
        weatherView.addSubview(weather)
        
        let cellStackView = UIStackView(arrangedSubviews: [dateAndTextView, clothesView, weatherView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.distribution = .fillEqually
        addSubview(cellStackView)
        
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            day.topAnchor.constraint(equalTo: dateAndTextView.topAnchor, constant: 10),
            day.leadingAnchor.constraint(equalTo: dateAndTextView.leadingAnchor, constant: 15),
            day.bottomAnchor.constraint(equalTo: dateAndTextView.bottomAnchor, constant: -10),
            
            clothes.topAnchor.constraint(equalTo: clothesView.topAnchor, constant: 15),
            clothes.leadingAnchor.constraint(equalTo: clothesView.leadingAnchor, constant: 15),
            clothes.bottomAnchor.constraint(equalTo: clothesView.bottomAnchor, constant: -15),
            clothes.trailingAnchor.constraint(equalTo: clothesView.trailingAnchor, constant: -15),
            
            weather.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 10),
            weather.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 25),
            weather.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -15),
            weather.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: -10),
            weather.centerYAnchor.constraint(equalTo: weatherView.centerYAnchor)
            ])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}

