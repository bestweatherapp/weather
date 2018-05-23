//
//  ViewController.swift
//  READING
//
//  Created by Валентина on 07.05.18.
//  Copyright © 2018 Валентина. All rights reserved.
//
//it works, bitches
import UIKit
import Foundation
import CoreLocation

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allHours.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! HourCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.hour.text = allHours[indexPath.item]
        cell.hourWeather.text = allHourlyTemps[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "tableViewcell", for: indexPath) as! DayCell
        cell.backgroundColor = UIColor.clear
        cell.day.text = allDates[indexPath.row]
        cell.weather.text = "\(Int(round(allTemps[indexPath.row])))°"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8) {
            self.forecastTableView.frame.origin.x = -self.view.frame.width + 25
            self.forecastCollectionView.frame.origin.x = -self.view.frame.width + 25
            self.currentTemp.frame.origin.x = -self.view.frame.width + 25
            self.backgroundImage.frame.origin.x = -70
            self.detailedMenu.frame.origin.x = 25
            self.currentCity.frame.origin.x = -self.view.frame.width + 25
            self.currentCondition.frame.origin.x = -self.view.frame.width + 25
            self.comment.frame.origin.x = -self.view.frame.width + 25
            self.slideOutMenuButton.frame.origin.x = -self.view.frame.width + 25
            self.searchButton.frame.origin.x = -50
            self.closeDetailedViewButton.frame.origin.x = 25
        }

    }
}
class ViewController:  UIViewController, CLLocationManagerDelegate  {
    
    var onceOnly = false
    var locationManager = CLLocationManager()
    var ResultForecastCity = ForecastCity()
    var row : Int = 0
    var allDates = [String](arrayLiteral: "","","","","","","")
    var allTemps = [Double](arrayLiteral: 0,0,0,0,0,0,0)
    // Добавил такую же переменную как и AllTemps и AllDates
    var allHours = ["","","","","","","","","","","",""]
    var allHourlyTemps = ["","","","","","","","","","","",""]
    var currentForecastCity = ForecastCity() // Full Info
    var CitySelectedFromPreferences = ""
    
    // DateLabel
    let currentDate: UITextView = {
        let date = UITextView()
        date.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        date.attributedText = attributedText
        return date
    }()
    
    // SettingsButton
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "search60"), for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(OpenSearchVC), for: .touchUpInside)
        return button
    }()
    
    // SlideOutMenuButton
    let slideOutMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu60"), for: .normal)
        button.addTarget(self, action: #selector(ShowSlideOutMenu), for: .touchUpInside)
        return button
    }()
    
    // CommentLabel
    let comment: UITextView = {
        let com = UITextView()
        com.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        com.attributedText = attributedText
        com.isEditable = false
        com.isSelectable = false
        //com.isScrollEnabled = false
        com.backgroundColor = UIColor.clear
        return com
    }()
  
    // ForecastTableView
    let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return tableView
    }()
    
    // ForecastCollectionView
    let forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 25
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // CurrentCityLabel
    let currentCity: UITextView = {
        let city = UITextView()
        city.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        city.attributedText = attributedText
        city.textAlignment = .center
        city.backgroundColor = UIColor.clear
        city.isEditable = false
        city.isSelectable = false
        city.isScrollEnabled = false
        return city
    }()
    
    // ConditionLabel
    let currentCondition: UITextView = {
        let condition = UITextView()
        condition.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        condition.attributedText = attributedText
        condition.isEditable = false
        condition.isSelectable = false
        condition.isScrollEnabled = false
        condition.backgroundColor = UIColor.clear
        return condition
    }()
    
    // CloseDetailedView
    let closeDetailedViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close60"), for: .normal)
        button.addTarget(self, action: #selector(HideDetailedView), for: .touchUpInside)
        return button
    }()
    
    // WindLabel
    let currentWind: UITextView = {
        let wind = UITextView()
        wind.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        wind.attributedText = attributedText
        return wind
    }()
    
    // SlideOutMenu
    let slideOutMenu: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
    }()
    
    // FavouriteCitiesTableView
    let favoriteCitiesTableView: UITableView = {
        let favC = UITableView()
        favC.translatesAutoresizingMaskIntoConstraints = false
        favC.backgroundColor = UIColor(white: 1, alpha: 0)
        favC.showsVerticalScrollIndicator = false
        return favC
    }()
    
    // TempLabel
    let currentTemp: UITextView = {
        let temp = UITextView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString()
        temp.attributedText = attributedText
        temp.isEditable = false
        temp.isSelectable = false
        temp.isScrollEnabled = false
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    // Background Image
    let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "background"))
        //image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // CloseMenuButton
    let closeMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu60"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(CloseSlideOutMenu), for: .touchUpInside)
        return button
    }()
    
    // OpenSettingsViewController
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(OpenSettingsViewController), for: .touchUpInside)
        return button
    }()
    
    // DetailedSlideView
    let detailedMenu: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //    @IBAction func SettingsButton(_ sender: Any) {
    //        var newUsersPreferences = PreferencesTableViewController()
    //        performSegue(withIdentifier: "GoToPreferences", sender: Any?.self)
    //    }
    // Тут я перехожу на новый SearchviewController, в котором будет осуществляться поиск и автодополнение слов.
    @objc private func OpenSearchVC() {
        let searchVC = SearchViewController()
        // Animate ViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionPush
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(searchVC, animated: true, completion: nil)
    }
    
    @objc private func OpenSettingsViewController() {
        let settingsVC = SettingsViewController()
        CloseSlideOutMenu()
        present(settingsVC, animated: true, completion: nil)
    }
    
    @objc private func ShowSlideOutMenu() {
        UIView.animate(withDuration: 0.6, animations: {
           self.slideOutMenu.frame.origin.x = 0
        }, completion: nil)
    }
    
    @objc private func CloseSlideOutMenu() {
        UIView.animate(withDuration: 0.6, animations: {
            self.slideOutMenu.frame.origin.x = -290
        }, completion: nil)
    }
    
    @objc private func HideDetailedView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.forecastTableView.frame.origin.x = 25
            self.forecastCollectionView.frame.origin.x = 25
            self.currentTemp.frame.origin.x = 25
            self.backgroundImage.frame.origin.x = 0
            self.detailedMenu.frame.origin.x = self.view.frame.width
            self.currentCity.frame.origin.x = 75
            self.currentCondition.frame.origin.x = 25
            self.comment.frame.origin.x = 25
            self.slideOutMenuButton.frame.origin.x = 25
            self.searchButton.frame.origin.x = self.view.frame.width - 75
        }, completion: nil)
    }
    
    
    override func viewDidLoad() {
    //    WeatherNetwork().getWeather { (toastmodel) in
    //         print(toastmodel.Current?.condition)
    //    }
        view.addSubview(backgroundImage)
        view.addSubview(forecastTableView)
        view.addSubview(currentCondition)
        view.addSubview(currentWind)
        view.addSubview(currentTemp)
        view.addSubview(currentDate)
        view.addSubview(currentCity)
        view.addSubview(comment)
        view.addSubview(searchButton)
        view.addSubview(forecastCollectionView)
        view.addSubview(slideOutMenuButton)
        view.addSubview(slideOutMenu)
        view.addSubview(favoriteCitiesTableView)
        view.addSubview(detailedMenu)

        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.FirstView = self
        UpdateInfo(city: "Current Location")
        super.viewDidLoad()
        WeatherNetwork().getWeather{ (toastmodel) in
            print(toastmodel.Current?.condition as Any)
        }
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingHeading()
        }
        //let currentLocation : CLLocation!
        //currentLocation = locationManager.location
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastCollectionView.dataSource = self
        forecastTableView.register(DayCell.self, forCellReuseIdentifier: "tableViewcell")
        forecastCollectionView.register(HourCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        LayOut()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier! == "GoToDetailedForecast")
//        {
//            let destInf : DetailedViewController =  (segue.destination as? DetailedViewController)!
//            destInf.indexFromFirst = self.row
//            destInf.dataFromFirst = self.currentForecastCity
//        }
//    }
    
    // Метод, который размещает всё на экране
    private func LayOut() {
        
        slideOutMenu.addSubview(closeMenuButton)
        slideOutMenu.addSubview(settingsButton)
        detailedMenu.addSubview(closeDetailedViewButton)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            forecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            forecastTableView.heightAnchor.constraint(equalToConstant: 200),
            
            forecastCollectionView.bottomAnchor.constraint(equalTo: forecastTableView.topAnchor, constant: -25),
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            forecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 70),
            
            comment.bottomAnchor.constraint(equalTo: forecastCollectionView.topAnchor, constant: -10),
            comment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            comment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            comment.heightAnchor.constraint(equalToConstant: 65),
            
            currentCondition.bottomAnchor.constraint(equalTo: comment.topAnchor),
            currentCondition.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            currentCondition.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            currentCondition.heightAnchor.constraint(equalToConstant: 50),
            
            currentTemp.bottomAnchor.constraint(equalTo: currentCondition.topAnchor),
            currentTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            currentTemp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            currentTemp.heightAnchor.constraint(equalToConstant: 100),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            
            slideOutMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            slideOutMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            slideOutMenuButton.heightAnchor.constraint(equalToConstant: 40),
            slideOutMenuButton.widthAnchor.constraint(equalToConstant: 40),
            
            currentCity.topAnchor.constraint(equalTo: slideOutMenuButton.topAnchor),
            currentCity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentCity.heightAnchor.constraint(equalToConstant: 40),
            currentCity.widthAnchor.constraint(equalToConstant: 200),
            
            slideOutMenu.topAnchor.constraint(equalTo: view.topAnchor),
            slideOutMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            slideOutMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slideOutMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -290),
            
            detailedMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            detailedMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.frame.width - 25),
            detailedMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            detailedMenu.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            detailedMenu.heightAnchor.constraint(equalToConstant: view.frame.height - 50),
            
            closeMenuButton.leadingAnchor.constraint(equalTo: slideOutMenu.leadingAnchor, constant: 25),
            closeMenuButton.topAnchor.constraint(equalTo: slideOutMenu.safeAreaLayoutGuide.topAnchor, constant: 25),
            closeMenuButton.heightAnchor.constraint(equalToConstant: 40),
            closeMenuButton.widthAnchor.constraint(equalToConstant: 40),
            
            settingsButton.topAnchor.constraint(equalTo: slideOutMenu.topAnchor, constant: 25),
            settingsButton.trailingAnchor.constraint(equalTo: slideOutMenu.trailingAnchor, constant: -25),
            settingsButton.heightAnchor.constraint(equalToConstant: 40),
            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            
            closeDetailedViewButton.trailingAnchor.constraint(equalTo: detailedMenu.trailingAnchor, constant: -25),
            closeDetailedViewButton.topAnchor.constraint(equalTo: detailedMenu.topAnchor, constant: 25),
            closeDetailedViewButton.widthAnchor.constraint(equalToConstant: 40),
            closeDetailedViewButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    let hour = Calendar.current.component(.hour, from: Date()) // Current Hour
    
    func UpdateInfo(city: String) {
//        var city = ""
//        if (self.CitySelectedFromPreferences != nil && self.CitySelectedFromPreferences != "")
//        {
//         city =  self.CitySelectedFromPreferences
//        }
//        else
    
     //   let currentLocation: CLLocation = locationManager.location!
        
        var allDates = [String]()
        var allTempsdays = [Double]()
        var allHours = [String]()
        var allHourlyTemps = [String]()
        let errorHasOccured: Bool = false
        let current_ = Current()
        //var defaultAllDays = [ForecastDay]()
        // // // // // // // //
        //let ResultMethod = ResultForecastCity.GetWeatherData(city: city)
        
     //if ( ResultMethod.0 == false)
     //{
        //var CityMethod = ResultMethod.1
        //var allDatesMethod = ResultMethod.2
        //var allTempsMethpd = ResultMethod.3
        //}
        let correctCity = city.replacingOccurrences(of: " ", with: "%20")
        let urlString2 = "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=Moscow&days=7"
        let url2 = URL(string: urlString2)
        let task2 = URLSession.shared.dataTask(with: url2!) {[weak self](data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    as! [String : AnyObject]
                guard let current = json["current"] as? [String : AnyObject]
                    else
                {
                    self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                    return
                }
                current_.temp = current["temp_c"] as? Double
                current_.datetime = current["last_updated"] as? String
                guard  let condition = current["condition"] as? [String : AnyObject]
                    else
                {
                    self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                    return
                }
                current_.condition = condition["text"] as? String
                
                current_.feelslike = current["feelslike_c"] as? Double
                current_.wind_dir = current["wind_dir"] as? String
                current_.wind_speed = current["wind_kph"] as? Double
                current_.wind_speed = round(current_.wind_speed! * 5/18)
                guard let forecast = json["forecast"] as? [String: AnyObject]
                    else
                {
                    self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                    return
                }
                let forecastday = forecast["forecastday"] as? [AnyObject]
                var allDays = [ForecastDay]()
                for index in 0...6
                {
                    guard let day1 = forecastday![index] as? [String : AnyObject]
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    var allhoursForDay = [AnyObject]()
                    //поля для forecastday
                    guard let day = day1["day"] as? [String : AnyObject]
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    var date_ = day1["date"] as? String //об
                    var dateparts = date_?.components(separatedBy: "-")
                    date_ = dateparts![2] + "." + dateparts![1]
                    allDates.append(date_!)
                    let comment_ = ""
                    guard let maxtemp_ = day["maxtemp_c"] as? Double//
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    guard let mintemp_ = day["mintemp_c"] as? Double
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    guard  let avgtemp_ = day["avgtemp_c"] as? Double
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    allTempsdays.append(avgtemp_)
                    guard var wind_max_ = day["maxwind_kph"] as? Double?
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                        
                    }
                    wind_max_ = wind_max_! * 5/18
                    guard let avghum_ = day["avghumidity"] as? Double
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    guard let uv_ = day["uv"] as? Double
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    guard let text = day["condition"] as? [String: AnyObject]
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    guard let condition_ = text["text"] as? String
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    guard let hoursArr = day1["hour"] as? [AnyObject]
                        else
                    {
                        self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                        return
                    }
                    var counter = 24 // days
                    for object in hoursArr
                    {
                        if counter>0
                        {
                            let newHour = ForecastHour()
                            guard let time = object["time"] as? String
                                else
                            {
                                self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                                return
                            }
                            var timeArr = time.split(separator: " ")
                            newHour.time = String(timeArr[1])
                            newHour.feelslike = object["feelslike_c"] as? Double
                            newHour.humidity =  object["humidity"] as? Double
                            newHour.pressure =  object["pressure_mb"] as? Double
                            guard let text = object["condition"] as? [String : AnyObject]
                                else
                            {
                                self?.AlertURLerror(message: "Sorry, some internet connection problems occured...")
                                return
                            }
                            newHour.condition = text["text"] as? String
                            newHour.icon = text["icon"] as? String
                            
                            newHour.temperature = object["temp_c"] as? Double
                            newHour.chance_of_rain = object["chance_of_rain"] as? String
                            newHour.will_it_rain = object["will_it_rain"] as? Int
                            newHour.will_it_snow = object["will_it_snow"] as? Int
                            allhoursForDay.append(newHour)
                            counter = counter-1
                        }
                    }//
                    let newDay = ForecastDay(avg_temp_c: avgtemp_, date: date_!,temperature_avg: avgtemp_, temperature_max: maxtemp_, temperature_min: mintemp_, windSpeed_max: wind_max_!, avghumidity: avghum_, comment: comment_, condition: condition_, uv: uv_, forecastHours: allhoursForDay as! [ForecastHour])
                    newDay.date = date_!
                    allDays.append(newDay)
                    self?.allDates = allDates
                    self?.allTemps = allTempsdays
                }
                if (self?.hour)! > 12 {
                    for i in 0..<24 {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                    }
                    if 24-(self?.hour)! < 12 {
                        for i in 0...12-(24-(self?.hour)!) {
                            allHours.append("\(i):00")
                            allHourlyTemps.append("\(String(describing: Int(round(allDays[1].AllHours![i].temperature!))))°C")
                        }
                    }
                } else {
                    for i in 0...(self?.hour)!+12 {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                    }
                }
                self?.allHours = allHours
                self?.allHourlyTemps = allHourlyTemps
                self?.currentForecastCity = ForecastCity(Current: current_, ForecastDay: allDays)
                DispatchQueue.main.async {
                    self?.forecastTableView.reloadData()
                    self?.forecastCollectionView.reloadData()
                    if errorHasOccured {
                        let alert = UIAlertController(title: "Error", message: "Invalid city", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    } else {
                        self?.currentCity.attributedText = NSAttributedString(string: city, attributes: [NSAttributedStringKey.font: UIFont.init(name: "MalgunGothic", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self?.currentDate.attributedText = NSAttributedString(string: current_.datetime!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self?.currentTemp.attributedText = NSAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font: UIFont.init(name: "MalgunGothic", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self?.currentWind.attributedText = NSAttributedString(string: String(current_.wind_speed!), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self?.currentCondition.attributedText = NSAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "MalgunGothic", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self?.forecastTableView.reloadData()
                        self?.forecastCollectionView.reloadData()
                        let methods = Methods()
                        let forecastday_ = self?.currentForecastCity.AllForecastDay![0]
                        var comment = methods.GetCurrentComment(Current : current_)
                        comment += methods.GetThunderComment(forecastday: forecastday_!)
                        self?.comment.attributedText = NSAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                       // var test = forecastday_?.GetThunderComment(forecastday: forecastday_!)
                       //  print (test)
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task2.resume()
        forecastTableView.layer.cornerRadius = 20
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastCollectionView.dataSource = self
    }
    func AlertURLerror (message : String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
//extension UITextView {
//    func centerVertically() {
//        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let size = sizeThatFits(fittingSize)
//        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
//        let positiveTopOffset = max(1, topOffset)
//        contentOffset.y = -positiveTopOffset
//    }
//}

