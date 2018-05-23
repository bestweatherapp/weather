//
//  HourCell.swift
//  READING
//
//  Created by Maxim Reshetov on 22.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

class HourCell: UICollectionViewCell {
    
    let hour: UITextView = {
        let h = UITextView()
        h.translatesAutoresizingMaskIntoConstraints = false
        h.backgroundColor = UIColor(white: 1, alpha: 0)
        h.isEditable = false
        h.isScrollEnabled = false
        h.isSelectable = false
        h.textAlignment = .center
        return h
    }()
    
    let hourWeather: UITextView = {
        let hw = UITextView()
        hw.translatesAutoresizingMaskIntoConstraints = false
        hw.backgroundColor = UIColor(white: 1, alpha: 0)
        hw.isEditable = false
        hw.isScrollEnabled = false
        hw.isSelectable = false
        hw.textAlignment = .center
        return hw
    }()
    
    
    func Layout() {
        
        let stackView = UIStackView(arrangedSubviews: [hour, hourWeather])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hour.topAnchor.constraint(equalTo: stackView.topAnchor),
            hour.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
            hour.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 5),
            hourWeather.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
            hourWeather.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            hourWeather.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 5)
            ])
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

