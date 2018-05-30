//
//  ViewController.swift
//  READING
//
//  Created by Валентина on 07.05.18.
//  Copyright © 2018 Валентина. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation
import UserNotifications
class Current : Methods
{
    var datetime: String?
    var temp : Double?
    var condition : String?
    var wind_speed : Double?
    var wind_dir : String?
    var feelslike : Double?
    override init (){}
}
class ForecastCity : ReadingMethods
{
    var Current : Current?
    var AllForecastDay : [ForecastDay]?
    init(Current : Current, ForecastDay : [ForecastDay]) {
        self.Current = Current
        self.AllForecastDay = ForecastDay
    }
    override init (){}
}
class ForecastHour
{
    var time : String?
    var condition : String?
    var temperature : Double?
    var pressure : Double?
    var will_it_rain : Int?// 1 ir 0
    var chance_of_rain : String?
    var will_it_snow : Int?//1 or 0
    var feelslike : Double?
    var humidity : Double?
    var icon : String?
    
    init (){}
}
class ForecastDay : Methods
{
    var date : String = ""
    var condition : String?//
    var avg_temp_c: Double?//
    var temperature_max:Double?//
    var temperature_min:Double?//
    var temperature_avg:Double?//
    var windSpeed_max:Double?//
    var avghumidity: Double?//
    var comment: String?//
    var uv : Double?//
    var AllHours :  [ForecastHour]?
    init(avg_temp_c : Double, date: String,temperature_avg:Double,temperature_max:Double,temperature_min:Double, windSpeed_max:Double,
         avghumidity: Double,  comment: String, condition : String, uv : Double, forecastHours : [ForecastHour])
    {
        self.avg_temp_c = avg_temp_c
        self.condition = condition
        self.temperature_avg=temperature_avg
        self.temperature_max=temperature_max
        self.temperature_min=temperature_min
        self.windSpeed_max=windSpeed_max
        self.avghumidity=avghumidity
        self.comment=comment
        self.uv = uv
        self.AllHours = forecastHours
    }
    override init(){}
}

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert];
   
    
    @IBOutlet weak var CurrentCityLabel: UILabel!
    var locationManager = CLLocationManager()
    var ResultForecastCity = ForecastCity()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    @IBAction func SettingsButton(_ sender: Any) {
        var newUsersPreferences = PreferencesTableViewController()
        performSegue(withIdentifier: "GoToPreferences", sender: Any?.self)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ForecastTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.backgroundColor = .clear
        cell?.textLabel?.text = self.allDates[indexPath.row]
        cell?.detailTextLabel?.text = String(self.allTemps[indexPath.row])
        return cell!
    }
    
    @IBOutlet weak var DateLabel: UILabel!
    var allDates = [String](arrayLiteral: "","","","","","","")
    var allTemps = [Double](arrayLiteral: 0,0,0,0,0,0,0)
    
    var currentForecastCity = ForecastCity ()//полная информация
    
    var CitySelectedFromPreferences = ""
    
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var CommnetLabel: UILabel!
    @IBOutlet weak var ForecastTableView: UITableView!
    @IBOutlet weak var ConditionLabel: UILabel!
    @IBOutlet weak var WindLabel: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    var row : Int = 0
    func assignbackground(){
        let background = UIImage(named: "город")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    override func viewDidLoad() {
      
    
        let delegate = UIApplication.shared.delegate as! AppDelegate
       delegate.FirstView = self
       // var city = "Moscow"
        UpdateInfo()
        super.viewDidLoad()
        WeatherNetwork().getWeather{ (ResultCity, allTempsdays, allDates) in
            self.currentForecastCity = ResultCity
            self.allDates = allDates
            self.allTemps = allTempsdays
            
        }
        ForecastTableView.layer.cornerRadius = 20
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingHeading()
        }
        let currentLocation : CLLocation!
        currentLocation = locationManager.location
        assignbackground()
        ForecastTableView.delegate = self
        ForecastTableView.dataSource = self
        
        if (self.CitySelectedFromPreferences != nil && self.CitySelectedFromPreferences != "")
        {
         //   var city =  self.CitySelectedFromPreferences
            UpdateInfo()
            
        }
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        UpdateInfo()
        let commentToNotification = self.CommnetLabel.text!
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = " to check current weather"
        content.sound = UNNotificationSound.default()
        var dateComponents = DateComponents()
        dateComponents.hour = 16
        dateComponents.minute = 38
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                title: "Delete", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                              actions: [deleteAction],
                                              intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        content.categoryIdentifier = "UYLReminderCategory"
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "GoToDetailedForecast")
        {
            let destInf : DetailedViewController =  (segue.destination as? DetailedViewController)!
            destInf.indexFromFirst = self.row
            destInf.dataFromFirst = self.currentForecastCity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ForecastTableView.deselectRow(at: indexPath, animated: true)
        let row  = indexPath.row
        self.row = indexPath.row
        var dayToNextView = self.currentForecastCity.AllForecastDay![row]
        performSegue(withIdentifier: "GoToDetailedForecast", sender: Any?.self)
    }
    
    func UpdateInfo ()
    {
        var city = ""
        if (self.CitySelectedFromPreferences != nil && self.CitySelectedFromPreferences != "")
        {
         city =  self.CitySelectedFromPreferences
        }
        else
        { city = "Moscow"}
        var allDates = [String]()
        var allTempsdays = [Double]()
        
        var errorHasOccured: Bool = false
        var current_ = Current()
        var defaultAllDays = [ForecastDay]()
        var ResultMethod = ResultForecastCity.GetWeatherData(city: city)
        
     if ( ResultMethod.0 == false)
     {
        var CityMethod = ResultMethod.1
        var allDatesMethod = ResultMethod.2
        var allTempsMethpd = ResultMethod.3
        }
        ///
        let urlString2 = "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(city)&days=7"
        let url2 = URL(string: urlString2)
        let task2 = URLSession.shared.dataTask(with: url2!)
        {
            [weak self](data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    as! [String : AnyObject]
                 let current = json["current"] as? [String : AnyObject]
                current_.temp = current!["temp_c"] as? Double
                current_.datetime = current!["last_updated"] as? String
                if let condition = current!["condition"] as? [String : AnyObject]
                {
                    current_.condition = condition["text"] as? String
                }
                current_.feelslike = current!["feelslike_c"] as? Double
                current_.wind_dir = current!["wind_dir"] as? String
                current_.wind_speed = current!["wind_kph"] as? Double
                current_.wind_speed = round(current_.wind_speed! * 5/18)
                let forecast = json["forecast"] as? [String: AnyObject]
                let forecastday = forecast!["forecastday"] as? [AnyObject]
                var allDays = [ForecastDay]()
                for index in 0...6
                {
                    print("it worksssss")
                    let day1 = forecastday![index] as? [String : AnyObject]
                    var allhoursForDay = [AnyObject]()
                    //поля для forecastday
                    let day = day1!["day"] as? [String : AnyObject]
                    
                    var date_ = day1!["date"] as? String //об
                    var dateparts = date_?.components(separatedBy: "-")
                    date_ = dateparts![2] + "." + dateparts![1]
                    allDates.append(date_!)
                    let comment_ = ""
                    let maxtemp_ = day!["maxtemp_c"] as? Double//
                    let mintemp_ = day!["mintemp_c"] as? Double
                    let avgtemp_ = day!["avgtemp_c"] as? Double
                    allTempsdays.append(avgtemp_!)
                    let wind_max_ = (day!["maxwind_kph"] as? Double)! * 5/18
                    let avghum_ = day!["avghumidity"] as? Double
                    let uv_ = day!["uv"] as? Double
                    
                    let text = day!["condition"] as? [String: AnyObject]
                    let condition_ = text!["text"] as? String
                    let hoursArr = day1!["hour"] as? [AnyObject]
                    var counter = 24 // days
                    for object in hoursArr!
                    {
                        if counter>0
                        {
                            let newHour = ForecastHour()
                            let time = object["time"] as? String
                            var timeArr = time!.split(separator: " ")
                            newHour.time = String(timeArr[1])
                            newHour.feelslike = object["feelslike_c"] as? Double
                            newHour.humidity =  object["humidity"] as? Double
                            newHour.pressure =  object["pressure_mb"] as? Double
                            let text = object["condition"] as? [String : AnyObject]
                            newHour.condition = text!["text"] as? String
                            newHour.icon = text!["icon"] as? String
                            
                            newHour.temperature = object["temp_c"] as? Double
                            newHour.chance_of_rain = object["chance_of_rain"] as? String
                            newHour.will_it_rain = object["will_it_rain"] as? Int
                            newHour.will_it_snow = object["will_it_snow"] as? Int
                            allhoursForDay.append(newHour)
                            counter = counter-1
                        }
                    }
                    let newDay = ForecastDay(avg_temp_c: avgtemp_!, date: date_!,temperature_avg: avgtemp_!, temperature_max: maxtemp_!, temperature_min: mintemp_!, windSpeed_max: wind_max_, avghumidity: avghum_!, comment: comment_, condition: condition_!, uv: uv_!, forecastHours: allhoursForDay as! [ForecastHour])
                    newDay.date = date_!
                    print(newDay.date)
                    allDays.append(newDay)
                    self?.allDates = allDates //
                    self?.allTemps = allTempsdays //
                    self?.currentForecastCity = ForecastCity(Current: current_, ForecastDay: allDays) //
                }
                DispatchQueue.main.async {
                    self?.ForecastTableView.reloadData()
                    if errorHasOccured {
                        let alert = UIAlertController(title: "Error", message: "Invalid city", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                    else{
                        self?.CurrentCityLabel.text! = city
                        self?.DateLabel.text! = current_.datetime!
                        self?.TempLabel.text! = String(current_.temp!)+" C"
                        self?.WindLabel.text! = String (current_.wind_speed!)
                        self?.ConditionLabel.text! = current_.condition!
                        self?.ForecastTableView.reloadData()
                        let methods = Methods()
                        let forecastday_ = self?.currentForecastCity.AllForecastDay![0]
                        var comment = methods.GetCurrentComment(Current : current_)
                        comment += methods.GetThunderComment(forecastday: forecastday_!)
                        self?.CommnetLabel.text! = comment
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task2.resume()
        ForecastTableView.layer.cornerRadius = 20
        assignbackground()
        ForecastTableView.delegate = self
        ForecastTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        if CheckInternet.Connection(){
            print ("Successfully connected!")
           
        }
        else {
            self.Alert(Message: "No internet connection :-(")
            
        }
    }
    func Alert (Message : String){
        let alert = UIAlertController(title: "Error", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

