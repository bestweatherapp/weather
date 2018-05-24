//
//  SearchViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 24.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let closeSearchViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(CloseSearchVC), for: .touchUpInside)
        return button
    }()
    
    @objc func CloseSearchVC() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionReveal
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: true, completion: nil)
    }
    
    private func LayOut() {
        view.addSubview(searchView)
        searchView.addSubview(closeSearchViewButton)
        closeSearchViewButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -25).isActive = true
        closeSearchViewButton.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 25).isActive = true
        closeSearchViewButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeSearchViewButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        searchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        LayOut()
    }
    
}
