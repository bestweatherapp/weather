//
//  HourCell.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class HourCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        LayOut()
    }
    
    private func LayOut() {
        let hourView = UIView()
        hourView.translatesAutoresizingMaskIntoConstraints = false
        hourView.backgroundColor = .green
        
        let temperatureIconView = UIView()
        temperatureIconView.translatesAutoresizingMaskIntoConstraints = false
        temperatureIconView.backgroundColor = .blue
        
        let weatherView = UIView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherView.backgroundColor = .purple
        
        let cellStackView = UIStackView(arrangedSubviews: [hourView, temperatureIconView, weatherView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        
    
        addSubview(cellStackView)
        cellStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        hourView.topAnchor.constraint(equalTo: cellStackView.topAnchor).isActive = true
        hourView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        hourView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        hourView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        temperatureIconView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        temperatureIconView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        //temperatureIconView.topAnchor.constraint(equalTo: hourView.bottomAnchor).isActive = true
        temperatureIconView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        weatherView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        weatherView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        //weatherView.topAnchor.constraint(equalTo: temperatureIconView.bottomAnchor).isActive = true
        weatherView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
