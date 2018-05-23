//
//  Request.swift
//  READING
//
//  Created by Maxim Reshetov on 22.05.2018.
//  Copyright © 2018 Валентина. All rights reserved.
//

import UIKit
import CoreLocation

let locationManager = CLLocationManager()

func UpdateInfo(city: String) {
    let currentLocation: CLLocation = locationManager.location!
    
    var allDates = [String]()
    var allTempsdays = [Double]()
    var allHours = [String]()
    var allHourlyTemps = [String]()
    let errorHasOccured: Bool = false
    let current_ = Current()
    let hour = Calendar.current.component(.hour, from: Date()) // Current Hour
    
    let correctCity = city.replacingOccurrences(of: " ", with: "%20")
    let urlString2 = (city == "Current Location") ?  "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&days=7" : "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(correctCity)&days=7"
    let url2 = URL(string: urlString2)
    URLSession.shared.dataTask(with: url2!) {(data, response, error) in
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                as! [String : AnyObject]
            let current = json["current"] as? [String : AnyObject]
            current_.temp = current!["temp_c"] as? Double
            current_.datetime = current!["last_updated"] as? String
            if let condition = current!["condition"] as? [String : AnyObject] {
                current_.condition = condition["text"] as? String
            }
            current_.feelslike = current!["feelslike_c"] as? Double
            current_.wind_dir = current!["wind_dir"] as? String
            current_.wind_speed = current!["wind_kph"] as? Double
            current_.wind_speed = round(current_.wind_speed! * 5/18)
            let forecast = json["forecast"] as? [String: AnyObject]
            let forecastday = forecast!["forecastday"] as? [AnyObject]
            var allDays = [ForecastDay]()
            for index in 0...6 {
                let day1 = forecastday![index] as? [String : AnyObject]
                var allhoursForDay = [AnyObject]()
                // Fields for forecastday
                let day = day1!["day"] as? [String : AnyObject]
                var date_ = day1!["date"] as? String
                var dateparts = date_?.components(separatedBy: "-")
                date_ = dateparts![2] + "." + dateparts![1]
                allDates.append(date_!)
                let comment_ = ""
                let maxtemp_ = day!["maxtemp_c"] as? Double
                let mintemp_ = day!["mintemp_c"] as? Double
                let avgtemp_ = day!["avgtemp_c"] as? Double
                allTempsdays.append(avgtemp_!)
                let wind_max_ = (day!["maxwind_kph"] as? Double)! * 5/18
                let avghum_ = day!["avghumidity"] as? Double
                let uv_ = day!["uv"] as? Double
                
                let text = day!["condition"] as? [String: AnyObject]
                let condition_ = text!["text"] as? String
                let hoursArr = day1!["hour"] as? [AnyObject]
                var counter = 24 // Days
                for object in  hoursArr! {
                    if counter>0 {
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
                        counter = counter - 1
                    }
                }
                let newDay = ForecastDay(avg_temp_c: avgtemp_!, date: date_!,temperature_avg: avgtemp_!, temperature_max: maxtemp_!, temperature_min: mintemp_!, windSpeed_max: wind_max_, avghumidity: avghum_!, comment: comment_, condition: condition_!, uv: uv_!, forecastHours: allhoursForDay as! [ForecastHour])
                newDay.date = date_!
                allDays.append(newDay)
//                self?.allDates = allDates
//                self?.allTemps = allTempsdays
            }
            if hour > 12 {
                for i in hour..<24 {
                    allHours.append("\(i):00")
                    allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                }
                if allHours.count < 12 {
                    for i in 0...12-allHours.count {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[1].AllHours![i].temperature!))))°C")
                    }
                }
            } else {
                for i in hour...hour+11 {
                    allHours.append("\(i):00")
                    allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                }
            }
//            self?.allHours = allHours
//            self?.allHourlyTemps = allHourlyTemps
//            self?.currentForecastCity = ForecastCity(Current: current_, ForecastDay: allDays)
            DispatchQueue.main.async {
                }
            }catch let jsonError {
            print(jsonError)
        }
    
}.resume()

}
