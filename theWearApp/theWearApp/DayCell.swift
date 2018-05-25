//
//  DayCell.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    let date: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        text.attributedText = attributedText
        text.textAlignment = .left
        return text
    }()
    
    let clothes: UIImageView = {
        let image = UIImageView(image: UIImage(named: "hooded-jacket"))
        return image
    }()
    
    let temperatureIcon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "page2"))
        return image
    }()
    
    let temperature: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "18 C", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 25)])
        text.attributedText = attributedText
        text.textAlignment = .right
        return text
    }()
    
    private func LayOut() {
        let dateAndTextView = UIView()
        dateAndTextView.translatesAutoresizingMaskIntoConstraints = false
        dateAndTextView.backgroundColor = .green
        
        let clothesView = UIView()
        clothesView.translatesAutoresizingMaskIntoConstraints = false
        clothesView.backgroundColor = .blue
        
        let weatherView = UIView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherView.backgroundColor = .purple
        
        let cellStackView = UIStackView(arrangedSubviews: [dateAndTextView, clothesView, weatherView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .horizontal
        addSubview(cellStackView)
        
        cellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        dateAndTextView.topAnchor.constraint(equalTo: cellStackView.topAnchor).isActive = true
        dateAndTextView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor).isActive = true
        dateAndTextView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor).isActive = true
        dateAndTextView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        clothesView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        clothesView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        clothesView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clothesView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        weatherView.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor).isActive = true
        weatherView.topAnchor.constraint(equalTo: cellStackView.topAnchor).isActive = true
        weatherView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor).isActive = true
        weatherView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        LayOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
