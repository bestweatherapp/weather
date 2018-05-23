//
//  SettingsViewController.swift
//  READING
//
//  Created by Maxim Reshetov on 22.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let top: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Blah", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 30), NSAttributedStringKey.foregroundColor:UIColor.gray])
        text.attributedText = attributedText
        text.backgroundColor = .red
        text.textAlignment = .center
        return text
    }()
    let bottom: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Blah", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 30), NSAttributedStringKey.foregroundColor:UIColor.gray])
        text.attributedText = attributedText
        text.backgroundColor = .green
        text.textAlignment = .center
        return text
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(scrollView)
        scrollView.addSubview(top)
        scrollView.addSubview(bottom)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            top.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            top.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            top.heightAnchor.constraint(equalToConstant: 80),
            top.widthAnchor.constraint(equalToConstant: 200),
            
            bottom.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            bottom.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
            bottom.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 1000),
            bottom.heightAnchor.constraint(equalToConstant: 80),
            bottom.widthAnchor.constraint(equalToConstant: 200)
            ])
        
        
    }
    
}
