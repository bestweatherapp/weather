//
//  DetailedViewController.swift
//  READING
//
//  Created by Валентина on 08.05.18.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBAction func Exit(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var UVLabel: UILabel!
    @IBOutlet weak var HumidityLabel: UILabel!
    @IBOutlet weak var WindLabel: UILabel!
    @IBOutlet weak var ImageEvening: UIImageView!
    @IBOutlet weak var ImageDay: UIImageView!
    @IBOutlet weak var ImageMorning: UIImageView!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var MorningLabel: UILabel!
    @IBOutlet weak var DayLabel: UILabel!
    
    @IBOutlet weak var DownEvening: UIImageView!
    @IBOutlet weak var UpEvening: UIImageView!
    @IBOutlet weak var DownDay: UIImageView!
    
    @IBOutlet weak var UpDay: UIImageView!
    @IBOutlet weak var DownMorning: UIImageView!
    @IBOutlet weak var EveningLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var UpMorning: UIImageView!
    var dataFromFirst = ForecastCity()
    var indexFromFirst = Int()
    var recievedobj = ForecastCity()
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        self.recievedobj = dataFromFirst
        currentDateLabel.text! = dataFromFirst.AllForecastDay![self.indexFromFirst].date
        var avg_morning : Double = 0
        var avg_day : Double = 0
        var avg_evening : Double = 0
        for  i in 6...11
        {
            avg_morning += dataFromFirst.AllForecastDay![indexFromFirst].AllHours![i].temperature!
        }
        avg_morning = avg_morning/6
        for i in 12...17
        {
            
            avg_day += dataFromFirst.AllForecastDay![indexFromFirst].AllHours![i].temperature!
            
        }
        avg_day = avg_day/6
        for i in 18...23
        {
                avg_evening += dataFromFirst.AllForecastDay![indexFromFirst].AllHours![i].temperature!
        }
        avg_evening = avg_evening/6
        MorningLabel.text! = String(round(avg_morning))
        DayLabel.text! = String (round(avg_day))
        EveningLabel.text! = String (round(avg_evening))
        CommentLabel.layer.cornerRadius = 20
        WindLabel.text! = String(Int(round(dataFromFirst.AllForecastDay![indexFromFirst].windSpeed_max!)))+" m/s"
       HumidityLabel.text! =  String(Int(round(dataFromFirst.AllForecastDay![indexFromFirst].avghumidity!)))+" %"
        UVLabel.text! = String(Int(round(dataFromFirst.AllForecastDay![indexFromFirst].uv!)))
        var methods = Methods()
        CommentLabel.text! = methods.GetFutureComment(day: dataFromFirst.AllForecastDay![indexFromFirst], avgmorning: avg_morning, avgday: avg_day, avgevening: avg_evening)
        switch (avg_morning)
        {
        case  -50 ..< -20:
            UpMorning.image?.accessibilityIdentifier = "куртка_толстовка"
        case -20 ..< 0:
        UpMorning.image?.accessibilityIdentifier = "куртка_толстовка"
        case 0 ..< 10:
             UpMorning = UIImageView(image: UIImage(named: "плащ_дождевик"))
        case 10 ..< 15:
            UpMorning = UIImageView(image: UIImage(named: "плащ_дождевик"))
    
        case 15 ..< 20:
            UpMorning = UIImageView(image: UIImage(named: "лонгслив"))
        case 20 ..< 25:
            UpMorning.image = UIImage(named : "рубашка")
        case 25 ..< 30:
           UpMorning.image = UIImage(named : "поло")
        default :
             UpMorning.image = UIImage(named : "футболка")  
        }
       
    }
  
    func assignbackground(){
        let background = UIImage(named: "city_background")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
   

}
