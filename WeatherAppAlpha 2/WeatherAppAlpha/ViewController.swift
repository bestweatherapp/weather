//
//  ViewController.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 07.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import UIKit
import CoreLocation

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentLocationIconImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonPressed(_ sender: UIButton) {
        citiesTableView.isEditing = !citiesTableView.isEditing
        let title = (citiesTableView.isEditing) ? "Done" : "Edit"
        editButton.setTitle(title, for: .normal)
        
        
    }
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    
    @IBAction func panGesturePerformed(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.menuView).x
            // Проверяем куда свайпаем
            if translation > 0 { // Свайп вправо
                if leadingConstraints.constant < 0 {
                    UIView.animate(withDuration: 0.2) {
                        self.leadingConstraints.constant += translation / 15
                        self.menuView.layoutIfNeeded()
                    }
                }
            } else { // Свайп влево
                if leadingConstraints.constant > -272 {
                    UIView.animate(withDuration: 0.2) {
                        self.leadingConstraints.constant += translation / 15
                        self.menuView.layoutIfNeeded()
                    }
                }
            }
            
            
        } else if sender.state == .ended {
            
            if leadingConstraints.constant < -100 {
                UIView.animate(withDuration: 0.5) {
                    self.leadingConstraints.constant = -272
                    self.menuView.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.leadingConstraints.constant = 0
                    self.menuView.layoutIfNeeded()
                }
            }
            
        }
        
    }
    
    
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraints.constant = 0
            self.menuView.layoutIfNeeded()
        }
    }
    
    

    @IBOutlet weak var currentTemp_cLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!

    let date = Date()
    let calendar = Calendar.current
    
    // Objects of class
    var weather = CurrentAndForecastWeather(dates: [], next12Hours: [], next12HoursTemp: [], next12HoursIcons: [], dayTemp_c: [], nightTemp_c: [], dayConditionIcon: [], morningTemps: [], morningTempsFeelsLike: [], afternoonTemps: [], afternoonTempsFeelsLike: [], eveningTemps: [], eveningTempsFeelsLike: [], nightTemps: [], nightTempsFeelsLike: [])
    var weatherForDetailView = WeatherForDetailView()
    var cityWeather = CurrentAndForecastWeather(dates: [], next12Hours: [], next12HoursTemp: [], next12HoursIcons: [], dayTemp_c: [], nightTemp_c: [], dayConditionIcon: [], morningTemps: [], morningTempsFeelsLike: [], afternoonTemps: [], afternoonTempsFeelsLike: [], eveningTemps: [], eveningTempsFeelsLike: [], nightTemps: [], nightTempsFeelsLike: [])
    
    
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var hourlyView: UIView!
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        citiesTableView.reloadData()
    }
    
    
    
    
    
    func convertDateFormaterForDailyForecastForDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: date!)
    }
    
    func convertDateFormaterForDailyForecastForDateDescription(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date!)
    }
    
    func convertDateFormaterForHourlyForecast(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date!)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
       var locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        leadingConstraints.constant = -272
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        let currentLocation : CLLocation!
        currentLocation = locationManager.location
        Request(cL: currentLocation)
        self.hourlyCollectionView.delegate = self
        self.hourlyCollectionView.dataSource = self
        
        self.dailyTableView.delegate = self
        self.dailyTableView.dataSource = self
        
        self.citiesTableView.delegate = self
        self.citiesTableView.dataSource = self
        
        dailyView.layer.cornerRadius = 20
        dailyTableView.backgroundColor = UIColor.clear
        hourlyView.layer.cornerRadius = 20
        hourlyCollectionView.backgroundColor = UIColor.clear
        citiesTableView.backgroundColor = UIColor.clear
    }
    
    func Request(cL: CLLocation) {
        let hour = calendar.component(.hour, from: date)
        let url = URL(string: "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(cL.coordinate.latitude),\(cL.coordinate.longitude)&days=7")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else {
                print("returned error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            // Location
            self.weather.currentLocation = "Текущее местоположение"
            //-------
            
            // Reading current
            if let current = json["current"] as? [String : AnyObject] {
                if let currentTemp_c = current["temp_c"] as? Double {
                    self.weather.currentTemp_c = Int(round(currentTemp_c))
                }
                if let condition = current["condition"] as? [String : AnyObject] {
                    if let text = condition["text"] as? String {
                        self.weather.text = text
                    }
                    if let icon = condition["icon"] as? String {
                        self.weather.icon = String(icon.dropFirst(2))
                    }
                }
            }
            //-------
            
            // Reading forecast
            if let forecast = json["forecast"] as? [String : AnyObject] {
                if let forecastday = forecast["forecastday"] as? [AnyObject] {
                    // Today
                    if let day = forecastday[0] as? [String : AnyObject] {
                        if let date = day["date"] as? String {
                            self.weather.dates.append(self.convertDateFormaterForDailyForecastForDate(date))
                            //self.weather.datesDescription.append(self.convertDateFormaterForDailyForecastForDateDescription(date))
                        }
                        if let dayday = day["day"] as? [String : AnyObject] {
                            if let condition = dayday["condition"] as? [String : AnyObject] {
                                if let icon = condition["icon"] as? String {
                                    self.weather.dayConditionIcon.append(String(icon.dropFirst(2)))
                                }
                            }
                        }
                        if let hours = day["hour"] as? [AnyObject] {
                            var avgTemp = 0
                            var avgTempFeelsLike = 0
                            for i in 0...4 { // Night
                                if let nightHour = hours[i] as? [String : AnyObject] {
                                    if let nightTemp_c = nightHour["temp_c"] as? Double {
                                        avgTemp += Int(round(nightTemp_c))
                                    }
                                    if let nightTemp_cFeelsLike = nightHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(nightTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.weather.nightTemp_c.append(Int(avgTemp / 5))
                            self.weather.nightTemps.append(Int(avgTempFeelsLike / 5))
                            self.weather.nightTempsFeelsLike.append(Int(avgTempFeelsLike / 5))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            for i in 5...11 { // Morning
                                if let morningHour = hours[i] as? [String : AnyObject] {
                                    if let morningTemp_c = morningHour["temp_c"] as? Double {
                                        avgTemp += Int(round(morningTemp_c))
                                    }
                                    if let morningTemp_cFeelsLike = morningHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(morningTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.weather.morningTemps.append(Int(avgTemp / 7))
                            self.weather.morningTempsFeelsLike.append(Int(avgTempFeelsLike / 7))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            for i in 12...15 { // Afternoon
                                if let afternoonHour = hours[i] as? [String : AnyObject] {
                                    if let afternoonTemp_c = afternoonHour["temp_c"] as? Double {
                                        avgTemp += Int(round(afternoonTemp_c))
                                    }
                                    if let afternoonTemp_cFeelsLike = afternoonHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(afternoonTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.weather.afternoonTemps.append(Int(avgTemp / 4))
                            self.weather.dayTemp_c.append(Int(avgTemp / 4))
                            self.weather.afternoonTempsFeelsLike.append(Int(avgTempFeelsLike / 4))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            for i in 16...23 { // Evening
                                if let eveningHour = hours[i] as? [String : AnyObject] {
                                    if let eveningTemp_c = eveningHour["temp_c"] as? Double {
                                        avgTemp += Int(round(eveningTemp_c))
                                    }
                                    if let eveningTemp_cFeelsLike = eveningHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(eveningTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.weather.eveningTemps.append(Int(avgTemp / 8))
                            self.weather.eveningTempsFeelsLike.append(Int(avgTempFeelsLike / 8))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            var check = 0
                            for m in hour...hour + 11 {
                                if m >= 24 {
                                    if let dayAddition = forecastday[1] as? [String : AnyObject] {
                                        if let hoursAddition = dayAddition["hour"] as? [AnyObject] {
                                            for k in m-24...11 - check {
                                                if let hAddition = hoursAddition[k] as? [String : AnyObject] {
                                                    if let time = hAddition["time"] as? String {
                                                        self.weather.next12Hours.append(self.convertDateFormaterForHourlyForecast(time).capitalized)
                                                    }
                                                    if let temp_c = hAddition["temp_c"] as? Double {
                                                        self.weather.next12HoursTemp.append(Int(round(temp_c)))
                                                    }
                                                    if let condition = hAddition["condition"] as? [String : AnyObject] {
                                                        if let icon = condition["icon"] as? String {
                                                            self.weather.next12HoursIcons.append(String(icon.dropFirst(2)))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    break
                                } else {
                                    check += 1
                                    if let h = hours[m] as? [String : AnyObject] {
                                        if let time = h["time"] as? String {
                                            self.weather.next12Hours.append(self.convertDateFormaterForHourlyForecast(time))
                                        }
                                        if let temp_c = h["temp_c"] as? Double {
                                            self.weather.next12HoursTemp.append(Int(round(temp_c)))
                                        }
                                        if let condition = h["condition"] as? [String : AnyObject] {
                                            if let icon = condition["icon"] as? String {
                                                self.weather.next12HoursIcons.append(String(icon.dropFirst(2)))
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    for n in 1...6 {
                        if let day = forecastday[n] as? [String : AnyObject] {
                            if let date = day["date"] as? String {
                                self.weather.dates.append(self.convertDateFormaterForDailyForecastForDate(date))
                                self.weather.datesDescription.append(self.convertDateFormaterForDailyForecastForDateDescription(date).capitalized)
                            }
                            if let dayday = day["day"] as? [String : AnyObject] {
                                if let condition = dayday["condition"] as? [String : AnyObject] {
                                    if let icon = condition["icon"] as? String {
                                        self.weather.dayConditionIcon.append(String(icon.dropFirst(2)))
                                    }
                                }
                            }
                            var avgTemp = 0
                            var avgTempFeelsLike = 0
                            if let hours = day["hour"] as? [AnyObject] {
                                for i in 0...4 { // Night
                                    if let nightHour = hours[i] as? [String : AnyObject] {
                                        if let nightTemp_c = nightHour["temp_c"] as? Double {
                                            avgTemp += Int(round(nightTemp_c))
                                        }
                                        if let nightTemp_cFeelslike = nightHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(nightTemp_cFeelslike))
                                        }
                                        
                                    }
                                }
                                self.weather.nightTemp_c.append(Int(avgTemp / 5))
                                self.weather.nightTemps.append(Int(avgTemp / 5))
                                self.weather.nightTempsFeelsLike.append(Int(avgTempFeelsLike / 5))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                                for i in 5...11 { // Morning
                                    if let morningHour = hours[i] as? [String : AnyObject] {
                                        if let morningTemp_c = morningHour["temp_c"] as? Double {
                                            avgTemp += Int(round(morningTemp_c))
                                        }
                                        if let morningTemp_cFeelsLike = morningHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(morningTemp_cFeelsLike))
                                        }
                                    }
                                }
                                self.weather.morningTemps.append(Int(avgTemp / 7))
                                self.weather.morningTempsFeelsLike.append(Int(avgTempFeelsLike / 7))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                                for i in 12...15 { // Afternoon
                                    if let afternoonHour = hours[i] as? [String : AnyObject] {
                                        if let afternoonTemp_c = afternoonHour["temp_c"] as? Double {
                                            avgTemp += Int(round(afternoonTemp_c))
                                        }
                                        if let afternoonTemp_cFeelsLike = afternoonHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(afternoonTemp_cFeelsLike))
                                        }
                                    }
                                }
                                self.weather.afternoonTemps.append(Int(avgTemp / 4))
                                self.weather.dayTemp_c.append(Int(avgTemp / 4))
                                self.weather.afternoonTempsFeelsLike.append(Int(avgTempFeelsLike / 4))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                                for i in 16...23 { // Evening
                                    if let eveningHour = hours[i] as? [String : AnyObject] {
                                        if let eveningTemp_c = eveningHour["temp_c"] as? Double {
                                            avgTemp += Int(round(eveningTemp_c))
                                        }
                                        if let eveningTemp_cFeelslike = eveningHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(eveningTemp_cFeelslike))
                                        }
                                    }
                                }
                                self.weather.eveningTemps.append(Int(avgTemp / 8))
                                self.weather.eveningTempsFeelsLike.append(Int(avgTempFeelsLike / 8))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                            }
                        }
                    }
                }
            }
            //-------
            
            DispatchQueue.main.async {
                self.currentLocationIconImage.isHidden = false
                self.dailyTableView.reloadData()
                self.hourlyCollectionView.reloadData()
                self.citiesTableView.reloadData()
                self.currentTemp_cLabel.text = "+\(String(describing: self.weather.currentTemp_c!))°"
                self.currentSummaryLabel.text = self.weather.text
                self.currentLocationLabel.text = self.weather.currentLocation
                self.currentLocationIconImage.image = self.weather.currentLocationIcon
            }
        }
        task.resume()
        
        
    }
    
    func RequestForCity(city: String) {
        
        let hour = calendar.component(.hour, from: date)
        let cityCity = city.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(cityCity)&days=7"
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else {
                print("returned error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            
            // Location
            self.weather.currentLocation = city
            //-------
            
            // New Object
            self.cityWeather.currentLocationIcon = #imageLiteral(resourceName: "currentLocationIcon")
            
            self.cityWeather.currentTemp_c = 0
            self.cityWeather.currentTemp_f = 0
            self.cityWeather.icon = ""
            self.cityWeather.text = ""
            self.cityWeather.next12Hours = [String]()
            self.cityWeather.next12HoursTemp = [Int]()
            self.cityWeather.next12HoursIcons = [String]()
            self.cityWeather.sunrise = ""
            self.cityWeather.sunset = ""
            self.cityWeather.dates = [String]()
            self.cityWeather.datesDescription = ["Сегодня"]
            self.cityWeather.dayTemp_c = [Int]()
            self.cityWeather.nightTemp_c = [Int]()
            self.cityWeather.dayConditionIcon = [String]()
            self.cityWeather.morningTemps = [Int]()
            self.cityWeather.morningTempsFeelsLike = [Int]()
            self.cityWeather.afternoonTemps = [Int]()
            self.cityWeather.afternoonTempsFeelsLike = [Int]()
            self.cityWeather.eveningTemps = [Int]()
            self.cityWeather.eveningTempsFeelsLike = [Int]()
            self.cityWeather.nightTemps = [Int]()
            self.cityWeather.nightTempsFeelsLike = [Int]()
            //-------
            
            // Reading current
            if let current = json["current"] as? [String : AnyObject] {
                if let currentTemp_c = current["temp_c"] as? Double {
                    self.cityWeather.currentTemp_c = Int(round(currentTemp_c))
                }
                if let condition = current["condition"] as? [String : AnyObject] {
                    if let text = condition["text"] as? String {
                        self.cityWeather.text = text
                    }
                    if let icon = condition["icon"] as? String {
                        self.cityWeather.icon = String(icon.dropFirst(2))
                    }
                }
            }
            //-------
            
            // Reading forecast
            if let forecast = json["forecast"] as? [String : AnyObject] {
                if let forecastday = forecast["forecastday"] as? [AnyObject] {
                    // Today
                    if let day = forecastday[0] as? [String : AnyObject] {
                        if let date = day["date"] as? String {
                            self.cityWeather.dates.append(self.convertDateFormaterForDailyForecastForDate(date))
                            //self.weather.datesDescription.append(self.convertDateFormaterForDailyForecastForDateDescription(date))
                        }
                        if let dayday = day["day"] as? [String : AnyObject] {
                            if let condition = dayday["condition"] as? [String : AnyObject] {
                                if let icon = condition["icon"] as? String {
                                    self.cityWeather.dayConditionIcon.append(String(icon.dropFirst(2)))
                                }
                            }
                        }
                        if let hours = day["hour"] as? [AnyObject] {
                            var avgTemp = 0
                            var avgTempFeelsLike = 0
                            for i in 0...4 { // Night
                                if let nightHour = hours[i] as? [String : AnyObject] {
                                    if let nightTemp_c = nightHour["temp_c"] as? Double {
                                        avgTemp += Int(round(nightTemp_c))
                                    }
                                    if let nightTemp_cFeelsLike = nightHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(nightTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.cityWeather.nightTemp_c.append(Int(avgTemp / 5))
                            self.cityWeather.nightTemps.append(Int(avgTempFeelsLike / 5))
                            self.cityWeather.nightTempsFeelsLike.append(Int(avgTempFeelsLike / 5))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            for i in 5...11 { // Morning
                                if let morningHour = hours[i] as? [String : AnyObject] {
                                    if let morningTemp_c = morningHour["temp_c"] as? Double {
                                        avgTemp += Int(round(morningTemp_c))
                                    }
                                    if let morningTemp_cFeelsLike = morningHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(morningTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.cityWeather.morningTemps.append(Int(avgTemp / 7))
                            self.cityWeather.morningTempsFeelsLike.append(Int(avgTempFeelsLike / 7))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            for i in 12...15 { // Afternoon
                                if let afternoonHour = hours[i] as? [String : AnyObject] {
                                    if let afternoonTemp_c = afternoonHour["temp_c"] as? Double {
                                        avgTemp += Int(round(afternoonTemp_c))
                                    }
                                    if let afternoonTemp_cFeelsLike = afternoonHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(afternoonTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.cityWeather.afternoonTemps.append(Int(avgTemp / 4))
                            self.cityWeather.dayTemp_c.append(Int(avgTemp / 4))
                            self.cityWeather.afternoonTempsFeelsLike.append(Int(avgTempFeelsLike / 4))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            for i in 16...23 { // Evening
                                if let eveningHour = hours[i] as? [String : AnyObject] {
                                    if let eveningTemp_c = eveningHour["temp_c"] as? Double {
                                        avgTemp += Int(round(eveningTemp_c))
                                    }
                                    if let eveningTemp_cFeelsLike = eveningHour["feelslike_c"] as? Double {
                                        avgTempFeelsLike += Int(round(eveningTemp_cFeelsLike))
                                    }
                                }
                            }
                            self.cityWeather.eveningTemps.append(Int(avgTemp / 8))
                            self.cityWeather.eveningTempsFeelsLike.append(Int(avgTempFeelsLike / 8))
                            avgTemp = 0
                            avgTempFeelsLike = 0
                            var check = 0
                            for m in hour...hour + 11 {
                                if m >= 24 {
                                    if let dayAddition = forecastday[1] as? [String : AnyObject] {
                                        if let hoursAddition = dayAddition["hour"] as? [AnyObject] {
                                            for k in m-24...11 - check {
                                                if let hAddition = hoursAddition[k] as? [String : AnyObject] {
                                                    if let time = hAddition["time"] as? String {
                                                        self.cityWeather.next12Hours.append(self.convertDateFormaterForHourlyForecast(time).capitalized)
                                                    }
                                                    if let temp_c = hAddition["temp_c"] as? Double {
                                                        self.cityWeather.next12HoursTemp.append(Int(round(temp_c)))
                                                    }
                                                    if let condition = hAddition["condition"] as? [String : AnyObject] {
                                                        if let icon = condition["icon"] as? String {
                                                            self.cityWeather.next12HoursIcons.append(String(icon.dropFirst(2)))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    break
                                } else {
                                    check += 1
                                    if let h = hours[m] as? [String : AnyObject] {
                                        if let time = h["time"] as? String {
                                            self.cityWeather.next12Hours.append(self.convertDateFormaterForHourlyForecast(time))
                                        }
                                        if let temp_c = h["temp_c"] as? Double {
                                            self.cityWeather.next12HoursTemp.append(Int(round(temp_c)))
                                        }
                                        if let condition = h["condition"] as? [String : AnyObject] {
                                            if let icon = condition["icon"] as? String {
                                                self.cityWeather.next12HoursIcons.append(String(icon.dropFirst(2)))
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    for n in 1...6 {
                        if let day = forecastday[n] as? [String : AnyObject] {
                            if let date = day["date"] as? String {
                                self.cityWeather.dates.append(self.convertDateFormaterForDailyForecastForDate(date))
                                self.cityWeather.datesDescription.append(self.convertDateFormaterForDailyForecastForDateDescription(date).capitalized)
                            }
                            if let dayday = day["day"] as? [String : AnyObject] {
                                if let condition = dayday["condition"] as? [String : AnyObject] {
                                    if let icon = condition["icon"] as? String {
                                        self.cityWeather.dayConditionIcon.append(String(icon.dropFirst(2)))
                                    }
                                }
                            }
                            var avgTemp = 0
                            var avgTempFeelsLike = 0
                            if let hours = day["hour"] as? [AnyObject] {
                                for i in 0...4 { // Night
                                    if let nightHour = hours[i] as? [String : AnyObject] {
                                        if let nightTemp_c = nightHour["temp_c"] as? Double {
                                            avgTemp += Int(round(nightTemp_c))
                                        }
                                        if let nightTemp_cFeelslike = nightHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(nightTemp_cFeelslike))
                                        }
                                        
                                    }
                                }
                                self.cityWeather.nightTemp_c.append(Int(avgTemp / 5))
                                self.cityWeather.nightTemps.append(Int(avgTemp / 5))
                                self.cityWeather.nightTempsFeelsLike.append(Int(avgTempFeelsLike / 5))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                                for i in 5...11 { // Morning
                                    if let morningHour = hours[i] as? [String : AnyObject] {
                                        if let morningTemp_c = morningHour["temp_c"] as? Double {
                                            avgTemp += Int(round(morningTemp_c))
                                        }
                                        if let morningTemp_cFeelsLike = morningHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(morningTemp_cFeelsLike))
                                        }
                                    }
                                }
                                self.cityWeather.morningTemps.append(Int(avgTemp / 7))
                                self.cityWeather.morningTempsFeelsLike.append(Int(avgTempFeelsLike / 7))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                                for i in 12...15 { // Afternoon
                                    if let afternoonHour = hours[i] as? [String : AnyObject] {
                                        if let afternoonTemp_c = afternoonHour["temp_c"] as? Double {
                                            avgTemp += Int(round(afternoonTemp_c))
                                        }
                                        if let afternoonTemp_cFeelsLike = afternoonHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(afternoonTemp_cFeelsLike))
                                        }
                                    }
                                }
                                self.cityWeather.afternoonTemps.append(Int(avgTemp / 4))
                                self.cityWeather.dayTemp_c.append(Int(avgTemp / 4))
                                self.cityWeather.afternoonTempsFeelsLike.append(Int(avgTempFeelsLike / 4))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                                for i in 16...23 { // Evening
                                    if let eveningHour = hours[i] as? [String : AnyObject] {
                                        if let eveningTemp_c = eveningHour["temp_c"] as? Double {
                                            avgTemp += Int(round(eveningTemp_c))
                                        }
                                        if let eveningTemp_cFeelslike = eveningHour["feelslike_c"] as? Double {
                                            avgTempFeelsLike += Int(round(eveningTemp_cFeelslike))
                                        }
                                    }
                                }
                                self.cityWeather.eveningTemps.append(Int(avgTemp / 8))
                                self.cityWeather.eveningTempsFeelsLike.append(Int(avgTempFeelsLike / 8))
                                avgTemp = 0
                                avgTempFeelsLike = 0
                            }
                        }
                    }
                }
            }
            //-------
            
            DispatchQueue.main.async {
                self.currentLocationIconImage.isHidden = true
                self.dailyTableView.reloadData()
                self.hourlyCollectionView.reloadData()
                self.citiesTableView.reloadData()
                self.currentTemp_cLabel.text = "+\(String(describing: self.cityWeather.currentTemp_c!))°"
                self.currentSummaryLabel.text = self.cityWeather.text
                self.currentLocationLabel.text = self.cityWeather.currentLocation
                self.currentLocationIconImage.image = self.cityWeather.currentLocationIcon
            }
        }
        task.resume()
        
        
    }
   
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.weather.currentLocation == "Текущее местоположение" {
           return self.weather.next12Hours.count
        } else {
           return self.cityWeather.next12Hours.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.weather.currentLocation == "Текущее местоположение" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EachHourCollectionViewCell", for: indexPath) as! EachHourCollectionViewCell
            cell.eachHourLabel.text = self.weather.next12Hours[indexPath.row]
            cell.eachHourTemp_cLabel.text = "+\(self.weather.next12HoursTemp[indexPath.row])°"
            cell.eachHourIconlabel.contentMode = .scaleToFill
            cell.eachHourIconlabel.downloadedFrom(link: "https://" + self.weather.next12HoursIcons[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EachHourCollectionViewCell", for: indexPath) as! EachHourCollectionViewCell
            cell.eachHourLabel.text = self.cityWeather.next12Hours[indexPath.row]
            cell.eachHourTemp_cLabel.text = "+\(self.cityWeather.next12HoursTemp[indexPath.row])°"
            cell.eachHourIconlabel.contentMode = .scaleToFill
            cell.eachHourIconlabel.downloadedFrom(link: "https://" + self.cityWeather.next12HoursIcons[indexPath.row])
            return cell
        }
        
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.dailyTableView {
            if self.weather.currentLocation == "Текущее местоположение" {
                return self.weather.dates.count
            } else {
                return self.cityWeather.dates.count
            }
            
        } else if tableView == self.citiesTableView {
            if let city = cities {
                return city.count
            } else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = UITableViewCell()
        
        if tableView == self.dailyTableView {
            if self.weather.currentLocation == "Текущее местоположение" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EachDayTableViewCell", for: indexPath) as! EachDayTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.date.text = self.weather.dates[indexPath.row]
                cell.dateDescription.text = self.weather.datesDescription[indexPath.row]
                cell.dayTemp_c.text = "+\(self.weather.dayTemp_c[indexPath.row])°"
                cell.nightTemp_c.text = "+\(self.weather.nightTemp_c[indexPath.row])°"
                cell.dayWeatherIcon.contentMode = .scaleToFill
                cell.dayWeatherIcon.downloadedFrom(link: "https://" + self.weather.dayConditionIcon[indexPath.row])
                return cell
            } else {
                print("1")
                let cell = tableView.dequeueReusableCell(withIdentifier: "EachDayTableViewCell", for: indexPath) as! EachDayTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.date.text = self.cityWeather.dates[indexPath.row]
                cell.dateDescription.text = self.cityWeather.datesDescription[indexPath.row]
                cell.dayTemp_c.text = "+\(self.cityWeather.dayTemp_c[indexPath.row])°"
                cell.nightTemp_c.text = "+\(self.cityWeather.nightTemp_c[indexPath.row])°"
                cell.dayWeatherIcon.contentMode = .scaleToFill
                cell.dayWeatherIcon.downloadedFrom(link: "https://" + self.cityWeather.dayConditionIcon[indexPath.row])
                return cell
            }
           
            
        } else if tableView == self.citiesTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesCellTableViewCell", for: indexPath) as! CitiesCellTableViewCell
            cell.backgroundColor = UIColor.clear
            if let city = cities {
                cell.city.text = city[indexPath.row]
            }
            return cell
        }
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.dailyTableView {
            
            if self.weather.currentLocation == "Текущее местоположение" {
                self.weatherForDetailView.morningTemp = self.weather.morningTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.morningTempFeelsLike = self.weather.morningTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                self.weatherForDetailView.afternoonTemp = self.weather.afternoonTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.afternoonTempFeelsLike = self.weather.afternoonTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                self.weatherForDetailView.eveningTemp = self.weather.eveningTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.eveningTempFeelsLike = self.weather.eveningTempsFeelsLike[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                self.weatherForDetailView.nightTemp = self.weather.nightTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.nightTempFeelsLike = self.weather.nightTempsFeelsLike[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                performSegue(withIdentifier: "showDetails", sender: self)
            } else {
                self.weatherForDetailView.morningTemp = self.cityWeather.morningTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.morningTempFeelsLike = self.cityWeather.morningTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                self.weatherForDetailView.afternoonTemp = self.cityWeather.afternoonTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.afternoonTempFeelsLike = self.cityWeather.afternoonTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                self.weatherForDetailView.eveningTemp = self.cityWeather.eveningTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.eveningTempFeelsLike = self.cityWeather.eveningTempsFeelsLike[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                self.weatherForDetailView.nightTemp = self.cityWeather.nightTemps[(dailyTableView.indexPathForSelectedRow?.row)!]
                self.weatherForDetailView.nightTempFeelsLike = self.cityWeather.nightTempsFeelsLike[(dailyTableView.indexPathForSelectedRow?.row)!]
                
                performSegue(withIdentifier: "showDetails", sender: self)
            }
            
        } else if tableView == self.citiesTableView {
            
            RequestForCity(city: cities![(citiesTableView.indexPathForSelectedRow?.row)!])
            UIView.animate(withDuration: 0.5) {
                self.leadingConstraints.constant = -272
                self.menuView.layoutIfNeeded()
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = cities![sourceIndexPath.row]
        cities?.remove(at: sourceIndexPath.row)
        cities?.insert(temp, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities?.remove(at: indexPath.row)
            citiesTableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DayDetailsViewController {
            if self.weather.currentLocation == "Текущее местоположение" {
                destination.catchedWeather = weatherForDetailView
                destination.forecastFor = "\(weather.dates[(dailyTableView.indexPathForSelectedRow?.row)!])"
            } else {
                destination.catchedWeather = weatherForDetailView
                destination.forecastFor = "\(cityWeather.dates[(dailyTableView.indexPathForSelectedRow?.row)!])"
            }
            
        }
    }

}


    


