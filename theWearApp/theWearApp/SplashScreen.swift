//
//  SplashScreen.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 26.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {
    
    private let weaLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Wea", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    
    private let theLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "the", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    
    private let rLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "r", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = .clear
        return text
    }()
    
    @objc func Animation(sender: Timer) {
        if !(UserDefaults.standard.bool(forKey: "firstTimeOpened")) {
            AppDelegate.sharedinstance().window?.rootViewController = ViewController()
        } else {
            AppDelegate.sharedinstance().window?.rootViewController = WelcomePage()
        }
    }
    
    func Animate() {
        
        UIView.animate(withDuration: 2) {
            //
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "untillLaunch"), object: nil)
        view.addSubview(weaLabel)
        view.addSubview(theLabel)
        view.addSubview(rLabel)
        
        weaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        weaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive = true
        theLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        theLabel.leadingAnchor.constraint(equalTo: weaLabel.trailingAnchor).isActive = true
        rLabel.leadingAnchor.constraint(equalTo: theLabel.trailingAnchor).isActive = true
        rLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        
        view.backgroundColor = .white
        Animate()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(Animation(sender:)), userInfo: nil, repeats: false)
    }
}
