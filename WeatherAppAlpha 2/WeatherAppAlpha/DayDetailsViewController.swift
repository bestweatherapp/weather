//
//  DayDetailsViewController.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 07.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    var catchedWeather : WeatherForDetailView!
    var forecastFor : String?
    
    @IBOutlet weak var forecastforLabel: UILabel!
    @IBOutlet weak var morningTemp: UILabel!
    @IBOutlet weak var morningTempFeelsLike: UILabel!
    
    @IBOutlet weak var afternoonTemp: UILabel!
    @IBOutlet weak var afternoonTempFeelsLike: UILabel!
    
    @IBOutlet weak var eveningTemp: UILabel!
    @IBOutlet weak var eveningTempFeelsLike: UILabel!
    
    @IBOutlet weak var nightTemp: UILabel!
    @IBOutlet weak var nightTempFeelsLike: UILabel!
    
   
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forecastforLabel.text = "Прогноз на \(String(describing: forecastFor!))"
        self.morningTemp.text = "+\(String(describing: self.catchedWeather.morningTemp!))°"
        self.morningTempFeelsLike.text = "+\(String(describing: self.catchedWeather.morningTempFeelsLike!))°"
        self.afternoonTemp.text = "+\(String(describing: self.catchedWeather.afternoonTemp!))°"
        self.afternoonTempFeelsLike.text = "+\(String(describing: self.catchedWeather.afternoonTempFeelsLike!))°"
        self.eveningTemp.text = "+\(String(describing: self.catchedWeather.eveningTemp!))°"
        self.eveningTempFeelsLike.text = "+\(String(describing: self.catchedWeather.eveningTempFeelsLike!))°"
        self.nightTemp.text = "+\(String(describing: self.catchedWeather.nightTemp!))°"
        self.nightTempFeelsLike.text = "+\(String(describing: self.catchedWeather.nightTempFeelsLike!))°"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
