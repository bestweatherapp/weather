//
//  ViewController.swift
//  theWearApp
//
//  Created by Maxim Reshetov on 23.05.2018.
//  Copyright © 2018 theWear. All rights reserved.
//

import UIKit
import CoreLocation

// Extension for downloading image from the URL
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
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! HourCell
        cell.hour.attributedText = NSAttributedString(string: allHours[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 12)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        cell.temperatureIcon.downloadedFrom(link: allHourlyTempsIcons[indexPath.row])
        cell.temperature.attributedText = NSAttributedString(string: allHourlyTemps[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 14)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.forecastTableView {
            return 7
        } else {
            return (cities?.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.forecastTableView {
            let cell = forecastTableView.dequeueReusableCell(withIdentifier: "tableViewcell", for: indexPath) as! DayCell
            
            cell.date.attributedText = NSAttributedString(string: allDates[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            cell.temperature.attributedText = NSAttributedString(string: allTemps[indexPath.row], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
            cell.backgroundColor = .clear
            cell.temperatureIcon.contentMode = .scaleToFill
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.temperatureIcon.downloadedFrom(link: allTempsIcons[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = cities?[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = .clear
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.forecastTableView {
//            updateDetailedView(index: indexPath.row)
                    UIView.animate(withDuration: 0.8) {
                        print("1")
                        self.topStackView.frame.origin.x = -self.view.frame.width
                        self.middleStackView.frame.origin.x = -self.view.frame.width
                        self.bottomStackView.frame.origin.x = -self.view.frame.width
                        self.detailedView.frame.origin.x = 25
                    }

        } else {
            self.forecastTableView.isUserInteractionEnabled = true
            self.forecastCollectionView.isUserInteractionEnabled = true
            self.searchButton.isUserInteractionEnabled = true
            self.bottomStackView.isUserInteractionEnabled = true
            self.topStackView.isUserInteractionEnabled = true
            self.middleStackView.isUserInteractionEnabled = true
            self.currentTemperature.isUserInteractionEnabled = true
            self.currentCondition.isUserInteractionEnabled = true
            self.currentAdvice.isUserInteractionEnabled = true
            self.currentLocation.isUserInteractionEnabled = true
            self.searchButton.isEnabled = true
            UpdateInfo(location: cities![(favouriteCitiesTableView.indexPathForSelectedRow?.row)!])
            UIView.animate(withDuration: 0.4) {
                    self.slideOutMenu.frame.origin.x = -250
                    self.blurEffectView.effect = nil
            }
            self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
        }
    }
//
//    func updateDetailedView(index: Int) {
//
//                        let tempIcons = [("https:" + self.currentForecastCity.AllForecastDay![index].AllHours![7].icon!), ("https:" + self.currentForecastCity.AllForecastDay![index].AllHours![12].icon!), ("https:" + self.currentForecastCity.AllForecastDay![index].AllHours![18].icon!), ("https:" + self.currentForecastCity.AllForecastDay![index].AllHours![0].icon!)]
//                        let temps = ["\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![7].temperature!)))°C", "\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![12].temperature!)))°C", "\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![18].temperature!)))°C", "\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![0].temperature!)))°C"]
//                        let tempsFeelsLike = ["\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![7].feelslike!)))°C", "\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![12].feelslike!)))°C", "\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![18].feelslike!)))°C", "\(Int(round(self.currentForecastCity.AllForecastDay![index].AllHours![0].feelslike!)))°C"]
//
//
//                            self.morningTempIconForDetailedWindow.downloadedFrom(link: tempIcons[0])
//                            self.morningTempForDetailedWindow.attributedText = NSAttributedString(string: temps[0], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//                            self.morningTempFeelsLikeForDetailedWindow.attributedText = NSAttributedString(string: tempsFeelsLike[0], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//
//                            self.afternoonTempIconForDetailedWindow.downloadedFrom(link: tempIcons[1])
//                            self.afternoonTempForDetailedWindow.attributedText = NSAttributedString(string: temps[1], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//                            self.afternoonTempFeelsLikeForDetailedWindow.attributedText = NSAttributedString(string: tempsFeelsLike[1], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//
//                            self.eveningTempIconForDetailedWindow.downloadedFrom(link: tempIcons[2])
//                            self.eveningTempForDetailedWindow.attributedText = NSAttributedString(string: temps[2], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//                            self.eveningTempFeelsLikeForDetailedWindow.attributedText = NSAttributedString(string: tempsFeelsLike[2], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//                            print("check")
//                            self.nightTempIconForDetailedWindow.downloadedFrom(link: tempIcons[3])
//                            self.nightTempForDetailedWindow.attributedText = NSAttributedString(string: temps[3], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//                            self.nightTempFeelsLikeForDetailedWindow.attributedText = NSAttributedString(string: tempsFeelsLike[3], attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
//
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let hour = Calendar.current.component(.hour, from: Date()) // Current Hour
    
    var ResultForecastCity = ForecastCity()
    var row : Int = 0
    var allDates = [String](repeating: "", count: 7)
    var allTemps = [String](repeating: "", count: 7)
    var allTempsIcons = [String](repeating: "", count: 7)
    // Добавил такую же переменную как и AllTemps и AllDates
    var allHours = [String](repeating: "", count: 12)
    var allHourlyTemps = [String](repeating: "", count: 12)
    var allHourlyTempsIcons = [String](repeating: "", count: 12)
    var currentForecastCity = ForecastCity() // полная информация
    var CitySelectedFromPreferences = ""
    
    private let slideOutMenu: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        return button
    }()
    
    @objc func showSettings() {
        let set = SettingsViewController()
        set.modalPresentationStyle = .overCurrentContext
        present(set, animated: true, completion: nil)
    }
    
    private let favouriteCitiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let updateWithCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString(string: "Current location", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 100)]), for: .normal)
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(UpdateWithCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "5704"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let splashScreen: UIView = {
        let view = UIView()
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    
    }()
    
    private let detailedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
    }()
    
    private let exampleDescription: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 4
        text.translatesAutoresizingMaskIntoConstraints = false
        text.attributedText = NSAttributedString(string: "-\n-\n-\n-", attributes: nil)
        return text
    }()
    
    // Morning
    private let morningTempForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let morningTempFeelsLikeForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let morningTempDescriptionForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Morning", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let morningTempIconForDetailedWindow: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // Afternoon
    private let afternoonTempForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let afternoonTempFeelsLikeForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let afternoonTempDescriptionForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Afternoon", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let afternoonTempIconForDetailedWindow: UIImageView = {
        let image = UIImageView(image: UIImage(named: "page2"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // Evening
    private let eveningTempForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let eveningTempFeelsLikeForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let eveningTempDescriptionForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Evening", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let eveningTempIconForDetailedWindow: UIImageView = {
        let image = UIImageView(image: UIImage(named: "page2"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // Night
    private let nightTempForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let nightTempFeelsLikeForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let nightTempDescriptionForDetailedWindow: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Night", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Light", size: 13)!, NSAttributedStringKey.foregroundColor:UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let nightTempIconForDetailedWindow: UIImageView = {
        let image = UIImageView(image: UIImage(named: "page2"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let closeDetailedViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = false
        button.addTarget(self, action: #selector(CloseDetailedView), for: .touchUpInside)
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(OpenSlideOutMenu), for: .touchUpInside)
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(OpenSearchVC), for: .touchUpInside)
        return button
    }()
    
    private let currentLocation: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
   
    private let currentTemperature: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
    
    private let currentCondition: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.backgroundColor = .clear
        return text
    }()
    
    private let currentAdvice: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.numberOfLines = 3
        return text
    }()
    
    private let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
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
    
    private var topStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private var middleStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    // Methods
    
    @objc private func OpenSearchVC() {
        let searchVC = SearchViewController()
        searchVC.modalPresentationStyle = .overCurrentContext
        // Animate ViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionReveal
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.forecastTableView.isUserInteractionEnabled = false
        self.forecastCollectionView.isUserInteractionEnabled = false
        self.searchButton.isUserInteractionEnabled = false
        self.bottomStackView.isUserInteractionEnabled = false
        self.topStackView.isUserInteractionEnabled = false
        self.middleStackView.isUserInteractionEnabled = false
        self.currentTemperature.isUserInteractionEnabled = false
        self.currentCondition.isUserInteractionEnabled = false
        self.currentAdvice.isUserInteractionEnabled = false
        self.currentLocation.isUserInteractionEnabled = false
        self.blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        }
        present(searchVC, animated: true, completion: nil)
    }
    @objc func CloseDetailedView() {
        UIView.animate(withDuration: 0.4) {
            self.topStackView.frame.origin.x = 25
            self.middleStackView.frame.origin.x = 25
            self.bottomStackView.frame.origin.x = 25
            self.detailedView.frame.origin.x = self.view.frame.width + 25
        }
    }
    @objc func OpenSlideOutMenu() {
        self.forecastTableView.isUserInteractionEnabled = false
        self.forecastCollectionView.isUserInteractionEnabled = false
        self.searchButton.isUserInteractionEnabled = false
        self.bottomStackView.isUserInteractionEnabled = false
        self.topStackView.isUserInteractionEnabled = false
        self.middleStackView.isUserInteractionEnabled = false
        self.currentTemperature.isUserInteractionEnabled = false
        self.currentCondition.isUserInteractionEnabled = false
        self.currentAdvice.isUserInteractionEnabled = false
        self.currentLocation.isUserInteractionEnabled = false
        self.blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.slideOutMenu.frame.origin.x = 0
            self.blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        }
    }
    
    @objc func UpdateWithCurrentLocation() {
        UpdateInfo(location: "Current location")
        self.forecastTableView.isUserInteractionEnabled = true
        self.forecastCollectionView.isUserInteractionEnabled = true
        self.searchButton.isUserInteractionEnabled = true
        self.bottomStackView.isUserInteractionEnabled = true
        self.topStackView.isUserInteractionEnabled = true
        self.middleStackView.isUserInteractionEnabled = true
        self.currentTemperature.isUserInteractionEnabled = true
        self.currentCondition.isUserInteractionEnabled = true
        self.currentAdvice.isUserInteractionEnabled = true
        self.currentLocation.isUserInteractionEnabled = true
        self.searchButton.isEnabled = true
        UIView.animate(withDuration: 0.4) {
            self.slideOutMenu.frame.origin.x = -250
            self.blurEffectView.effect = nil
        }
        self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.slideOutMenu && self.slideOutMenu.frame.origin.x == 0 {
            self.forecastTableView.isUserInteractionEnabled = true
            self.forecastCollectionView.isUserInteractionEnabled = true
            self.searchButton.isUserInteractionEnabled = true
            self.bottomStackView.isUserInteractionEnabled = true
            self.topStackView.isUserInteractionEnabled = true
            self.middleStackView.isUserInteractionEnabled = true
            self.currentTemperature.isUserInteractionEnabled = true
            self.currentCondition.isUserInteractionEnabled = true
            self.currentAdvice.isUserInteractionEnabled = true
            self.currentLocation.isUserInteractionEnabled = true
            self.searchButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.slideOutMenu.frame.origin.x = -250
                self.blurEffectView.effect = nil
            }
            self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
        }

    }
    
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.effect = nil
        return blur
    }()
    
    private let detailedTop: UIView =  {
        let view = UIView()
        return view
    }()
    
    private func LayOut() {
        view.addSubview(detailedView)
        slideOutMenu.addSubview(favouriteCitiesTableView)
        slideOutMenu.addSubview(updateWithCurrentLocationButton)
        slideOutMenu.addSubview(updateWithCurrentLocationButton)
        
        updateWithCurrentLocationButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        detailedView.addSubview(closeDetailedViewButton)
        detailedView.addSubview(scrollView)
        scrollView.addSubview(detailedTop)
        scrollView.addSubview(exampleDescription)
        bottomStackView.addArrangedSubview(forecastCollectionView)
        bottomStackView.addArrangedSubview(forecastTableView)
        view.addSubview(bottomStackView)
        
        detailedTop.addSubview(morningTempForDetailedWindow)
        detailedTop.addSubview(morningTempIconForDetailedWindow)
        detailedTop.addSubview(morningTempDescriptionForDetailedWindow)
        detailedTop.addSubview(morningTempFeelsLikeForDetailedWindow)
        
        detailedTop.addSubview(afternoonTempForDetailedWindow)
        detailedTop.addSubview(afternoonTempIconForDetailedWindow)
        detailedTop.addSubview(afternoonTempDescriptionForDetailedWindow)
        detailedTop.addSubview(afternoonTempFeelsLikeForDetailedWindow)
        
        detailedTop.addSubview(eveningTempForDetailedWindow)
        detailedTop.addSubview(eveningTempIconForDetailedWindow)
        detailedTop.addSubview(eveningTempDescriptionForDetailedWindow)
        detailedTop.addSubview(eveningTempFeelsLikeForDetailedWindow)
        
        detailedTop.addSubview(nightTempForDetailedWindow)
        detailedTop.addSubview(nightTempIconForDetailedWindow)
        detailedTop.addSubview(nightTempDescriptionForDetailedWindow)
        detailedTop.addSubview(nightTempFeelsLikeForDetailedWindow)
        
        detailedTop.topAnchor.constraint(equalTo: detailedView.topAnchor).isActive = true
        detailedTop.leadingAnchor.constraint(equalTo: detailedView.leadingAnchor).isActive = true
        detailedTop.trailingAnchor.constraint(equalTo: detailedView.trailingAnchor).isActive = true
        detailedTop.heightAnchor.constraint(equalToConstant: 115).isActive = true
        
        middleStackView.addArrangedSubview(currentTemperature)
        middleStackView.addArrangedSubview(currentCondition)
        middleStackView.addArrangedSubview(currentAdvice)
        view.addSubview(middleStackView)
        
        topStackView.addArrangedSubview(menuButton)
        topStackView.addArrangedSubview(currentLocation)
        topStackView.addArrangedSubview(searchButton)
        view.addSubview(topStackView)
        self.view.addSubview(self.blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.blurEffectView.isHidden = true
        slideOutMenu.addSubview(settingsButton)
        
        settingsButton.topAnchor.constraint(equalTo: slideOutMenu.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: slideOutMenu.leadingAnchor, constant: 25).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(slideOutMenu)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5")
        case 1334:
            print("iPhone 6")
            
            exampleDescription.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 310).isActive = true
            exampleDescription.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 60).isActive = true
            exampleDescription.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -60).isActive = true
            exampleDescription.heightAnchor.constraint(equalToConstant: 310).isActive = true
            
            slideOutMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -290).isActive = true
            slideOutMenu.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            slideOutMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            slideOutMenu.widthAnchor.constraint(equalToConstant: 250).isActive = true
            
            closeDetailedViewButton.trailingAnchor.constraint(equalTo: detailedView.trailingAnchor, constant: -25).isActive = true
            closeDetailedViewButton.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 25).isActive = true
            closeDetailedViewButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeDetailedViewButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            favouriteCitiesTableView.topAnchor.constraint(equalTo: slideOutMenu.topAnchor, constant: 150).isActive = true
            favouriteCitiesTableView.bottomAnchor.constraint(equalTo: slideOutMenu.bottomAnchor, constant: -150).isActive = true
            favouriteCitiesTableView.leadingAnchor.constraint(equalTo: slideOutMenu.leadingAnchor, constant: 50).isActive = true
            favouriteCitiesTableView.trailingAnchor.constraint(equalTo: slideOutMenu.trailingAnchor, constant: -50).isActive = true
            
            updateWithCurrentLocationButton.bottomAnchor.constraint(equalTo: favouriteCitiesTableView.topAnchor, constant: -10).isActive = true
            updateWithCurrentLocationButton.leadingAnchor.constraint(equalTo: slideOutMenu.leadingAnchor, constant: 15).isActive = true
            updateWithCurrentLocationButton.trailingAnchor.constraint(equalTo: slideOutMenu.trailingAnchor, constant: -15).isActive = true
            updateWithCurrentLocationButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
            
            //----------------------Detailed View
            
            morningTempIconForDetailedWindow.topAnchor.constraint(equalTo: detailedTop.topAnchor, constant: 20).isActive = true
            morningTempIconForDetailedWindow.leadingAnchor.constraint(equalTo: detailedTop.leadingAnchor, constant: 33).isActive = true
            morningTempIconForDetailedWindow.bottomAnchor.constraint(equalTo: detailedTop.bottomAnchor, constant: -10).isActive = true
            morningTempIconForDetailedWindow.widthAnchor.constraint(equalToConstant: 40).isActive = true
            morningTempIconForDetailedWindow.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            afternoonTempIconForDetailedWindow.topAnchor.constraint(equalTo: detailedTop.topAnchor, constant: 20).isActive = true
            afternoonTempIconForDetailedWindow.leadingAnchor.constraint(equalTo: morningTempIconForDetailedWindow.trailingAnchor, constant: 33).isActive = true
            afternoonTempIconForDetailedWindow.bottomAnchor.constraint(equalTo: detailedTop.bottomAnchor, constant: -10).isActive = true
            afternoonTempIconForDetailedWindow.widthAnchor.constraint(equalToConstant: 40).isActive = true
            afternoonTempIconForDetailedWindow.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            eveningTempIconForDetailedWindow.topAnchor.constraint(equalTo: detailedTop.topAnchor, constant: 20).isActive = true
            eveningTempIconForDetailedWindow.leadingAnchor.constraint(equalTo: afternoonTempIconForDetailedWindow.trailingAnchor, constant: 33).isActive = true
            eveningTempIconForDetailedWindow.bottomAnchor.constraint(equalTo: detailedTop.bottomAnchor, constant: -10).isActive = true
            eveningTempIconForDetailedWindow.widthAnchor.constraint(equalToConstant: 40).isActive = true
            eveningTempIconForDetailedWindow.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            nightTempIconForDetailedWindow.topAnchor.constraint(equalTo: detailedTop.topAnchor, constant: 20).isActive = true
            nightTempIconForDetailedWindow.leadingAnchor.constraint(equalTo: eveningTempIconForDetailedWindow.trailingAnchor, constant: 33).isActive = true
            nightTempIconForDetailedWindow.bottomAnchor.constraint(equalTo: detailedTop.bottomAnchor, constant: -10).isActive = true
            nightTempIconForDetailedWindow.widthAnchor.constraint(equalToConstant: 40).isActive = true
            nightTempIconForDetailedWindow.heightAnchor.constraint(equalToConstant: 40).isActive = true
            //--------------
            morningTempForDetailedWindow.topAnchor.constraint(equalTo: morningTempIconForDetailedWindow.bottomAnchor, constant: 5).isActive = true
            morningTempForDetailedWindow.centerXAnchor.constraint(equalTo: morningTempIconForDetailedWindow.centerXAnchor).isActive = true
            morningTempForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            morningTempForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            afternoonTempForDetailedWindow.topAnchor.constraint(equalTo: afternoonTempIconForDetailedWindow.bottomAnchor, constant: 5).isActive = true
            afternoonTempForDetailedWindow.centerXAnchor.constraint(equalTo: afternoonTempIconForDetailedWindow.centerXAnchor).isActive = true
            afternoonTempForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            afternoonTempForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            eveningTempForDetailedWindow.topAnchor.constraint(equalTo: eveningTempIconForDetailedWindow.bottomAnchor, constant: 5).isActive = true
            eveningTempForDetailedWindow.centerXAnchor.constraint(equalTo: eveningTempIconForDetailedWindow.centerXAnchor).isActive = true
            eveningTempForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            eveningTempForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            nightTempForDetailedWindow.topAnchor.constraint(equalTo: nightTempIconForDetailedWindow.bottomAnchor, constant: 5).isActive = true
            nightTempForDetailedWindow.centerXAnchor.constraint(equalTo: nightTempIconForDetailedWindow.centerXAnchor).isActive = true
            nightTempForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            nightTempForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            //--------------
            
            //---------------
            morningTempFeelsLikeForDetailedWindow.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 240).isActive = true
            morningTempFeelsLikeForDetailedWindow.centerXAnchor.constraint(equalTo: morningTempIconForDetailedWindow.centerXAnchor).isActive = true
            morningTempFeelsLikeForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            morningTempFeelsLikeForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            afternoonTempFeelsLikeForDetailedWindow.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 240).isActive = true
            afternoonTempFeelsLikeForDetailedWindow.centerXAnchor.constraint(equalTo: afternoonTempForDetailedWindow.centerXAnchor).isActive = true
            afternoonTempFeelsLikeForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            afternoonTempFeelsLikeForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            eveningTempFeelsLikeForDetailedWindow.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 240).isActive = true
            eveningTempFeelsLikeForDetailedWindow.centerXAnchor.constraint(equalTo: eveningTempIconForDetailedWindow.centerXAnchor).isActive = true
            eveningTempFeelsLikeForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            eveningTempFeelsLikeForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            nightTempFeelsLikeForDetailedWindow.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 240).isActive = true
            nightTempFeelsLikeForDetailedWindow.centerXAnchor.constraint(equalTo: nightTempIconForDetailedWindow.centerXAnchor).isActive = true
            nightTempFeelsLikeForDetailedWindow.widthAnchor.constraint(equalToConstant: 50).isActive = true
            nightTempFeelsLikeForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            //--------------
            morningTempDescriptionForDetailedWindow.topAnchor.constraint(equalTo: morningTempForDetailedWindow.bottomAnchor, constant: 10).isActive = true
            morningTempDescriptionForDetailedWindow.centerXAnchor.constraint(equalTo: morningTempForDetailedWindow.centerXAnchor).isActive = true
            morningTempDescriptionForDetailedWindow.widthAnchor.constraint(equalToConstant: 55).isActive = true
            morningTempDescriptionForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            afternoonTempDescriptionForDetailedWindow.topAnchor.constraint(equalTo: afternoonTempForDetailedWindow.bottomAnchor, constant: 10).isActive = true
            afternoonTempDescriptionForDetailedWindow.centerXAnchor.constraint(equalTo: afternoonTempForDetailedWindow.centerXAnchor).isActive = true
            afternoonTempDescriptionForDetailedWindow.widthAnchor.constraint(equalToConstant: 55).isActive = true
            afternoonTempDescriptionForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            eveningTempDescriptionForDetailedWindow.topAnchor.constraint(equalTo: eveningTempForDetailedWindow.bottomAnchor, constant: 10).isActive = true
            eveningTempDescriptionForDetailedWindow.centerXAnchor.constraint(equalTo: eveningTempForDetailedWindow.centerXAnchor).isActive = true
            eveningTempDescriptionForDetailedWindow.widthAnchor.constraint(equalToConstant: 55).isActive = true
            eveningTempDescriptionForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            nightTempDescriptionForDetailedWindow.topAnchor.constraint(equalTo: nightTempForDetailedWindow.bottomAnchor, constant: 10).isActive = true
            nightTempDescriptionForDetailedWindow.centerXAnchor.constraint(equalTo: nightTempForDetailedWindow.centerXAnchor).isActive = true
            nightTempDescriptionForDetailedWindow.widthAnchor.constraint(equalToConstant: 55).isActive = true
            nightTempDescriptionForDetailedWindow.heightAnchor.constraint(equalToConstant: 30).isActive = true
            //----------------------]
            let DescriptionLine1 = UIBezierPath()
            DescriptionLine1.move(to: CGPoint(x: 25, y: 290))
            DescriptionLine1.addLine(to: CGPoint(x: 130, y: 290))
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            let shapeLayer5 = CAShapeLayer()
            shapeLayer5.path = DescriptionLine1.cgPath
            shapeLayer5.strokeColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
            shapeLayer5.fillColor = UIColor.clear.cgColor
            shapeLayer5.lineWidth = 1
            detailedView.layer.addSublayer(shapeLayer5)
            //-------------
            let descp = UILabel()
            descp.translatesAutoresizingMaskIntoConstraints = false
            descp.attributedText = NSAttributedString(string: "Description", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 13)!])
            detailedView.addSubview(descp)
            descp.centerXAnchor.constraint(equalTo: detailedView.centerXAnchor).isActive = true
            descp.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 280).isActive = true
            //-------------
            let DescriptionLine2 = UIBezierPath()
            DescriptionLine2.move(to: CGPoint(x: 195, y: 290))
            DescriptionLine2.addLine(to: CGPoint(x: 300, y: 290))
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            let shapeLayer32 = CAShapeLayer()
            shapeLayer32.path = DescriptionLine2.cgPath
            shapeLayer32.strokeColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
            shapeLayer32.fillColor = UIColor.clear.cgColor
            shapeLayer32.lineWidth = 1
            detailedView.layer.addSublayer(shapeLayer32)
            //-------------
           
            
            //-------Lines
            let topLine = UIBezierPath()
            topLine.move(to: CGPoint(x: 25, y: 85))
            topLine.addLine(to: CGPoint(x: 300, y: 85))
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            let shapeLayer1 = CAShapeLayer()
            shapeLayer1.path = topLine.cgPath
            shapeLayer1.strokeColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
            shapeLayer1.fillColor = UIColor.clear.cgColor
            shapeLayer1.lineWidth = 1
            detailedView.layer.addSublayer(shapeLayer1)
            //-------------
            let feelsLikeLine1 = UIBezierPath()
            feelsLikeLine1.move(to: CGPoint(x: 25, y: 225))
            feelsLikeLine1.addLine(to: CGPoint(x: 135, y: 225))
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            let shapeLayer2 = CAShapeLayer()
            shapeLayer2.path = feelsLikeLine1.cgPath
            shapeLayer2.strokeColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
            shapeLayer2.fillColor = UIColor.clear.cgColor
            shapeLayer2.lineWidth = 1
            detailedView.layer.addSublayer(shapeLayer2)
            //-------------
            let feelsLike = UILabel()
            feelsLike.translatesAutoresizingMaskIntoConstraints = false
            feelsLike.attributedText = NSAttributedString(string: "Feels like", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Ultralight", size: 13)!])
            detailedView.addSubview(feelsLike)
            feelsLike.centerXAnchor.constraint(equalTo: detailedView.centerXAnchor).isActive = true
            feelsLike.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 215).isActive = true
            //-------------
            let feelsLikeLine2 = UIBezierPath()
            feelsLikeLine2.move(to: CGPoint(x: 190, y: 225))
            feelsLikeLine2.addLine(to: CGPoint(x: 300, y: 225))
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            let shapeLayer3 = CAShapeLayer()
            shapeLayer3.path = feelsLikeLine2.cgPath
            shapeLayer3.strokeColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 80).cgColor
            shapeLayer3.fillColor = UIColor.clear.cgColor
            shapeLayer3.lineWidth = 1
            detailedView.layer.addSublayer(shapeLayer3)
            //-------------
            
            scrollView.topAnchor.constraint(equalTo: detailedView.topAnchor, constant: 75).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: detailedView.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: detailedView.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: detailedView.bottomAnchor, constant: -75).isActive = true
            
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
            bottomStackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
            middleStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -5).isActive = true
            middleStackView.heightAnchor.constraint(equalToConstant: 210).isActive = true
            
            currentTemperature.topAnchor.constraint(equalTo: middleStackView.topAnchor, constant: 10).isActive = true
            currentTemperature.bottomAnchor.constraint(equalTo: currentCondition.topAnchor, constant: -5).isActive = true
            currentTemperature.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor).isActive = true
            currentTemperature.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor).isActive = true
            
            currentCondition.bottomAnchor.constraint(equalTo: currentAdvice.topAnchor).isActive = true
            currentCondition.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor).isActive = true
            currentCondition.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor).isActive = true
            currentCondition.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            currentAdvice.bottomAnchor.constraint(equalTo: middleStackView.bottomAnchor).isActive = true
            currentAdvice.leadingAnchor.constraint(equalTo: middleStackView.leadingAnchor).isActive = true
            currentAdvice.trailingAnchor.constraint(equalTo: middleStackView.trailingAnchor).isActive = true
            currentAdvice.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
            topStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            forecastCollectionView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
            forecastCollectionView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
            forecastCollectionView.bottomAnchor.constraint(equalTo: forecastTableView.topAnchor, constant: -25).isActive = true
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 75).isActive = true
            forecastTableView.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor).isActive = true
            forecastTableView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor).isActive = true
            forecastTableView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor).isActive = true
            forecastTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
            menuButton.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor).isActive = true
            menuButton.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
            menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            searchButton.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor).isActive = true
            searchButton.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
            searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            currentLocation.topAnchor.constraint(equalTo: topStackView.topAnchor).isActive = true
            currentLocation.widthAnchor.constraint(equalToConstant: 185).isActive = true
            currentLocation.heightAnchor.constraint(equalToConstant: 40).isActive = true
            currentLocation.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor).isActive = true
            detailedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width + 25).isActive = true
            detailedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
            detailedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
            detailedView.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
            
        case 2208:
            print("iPhone 6+")
        case 2436:
            print("iPhone X")
        default:
            return
        }
        
    }
    
    func UpdateInfo(location: String) {
        
        var allDates = [String]()
        var allTempsdays = [String]()
        var allTempsdaysIcons = [String]()
        var allHours = [String]()
        var allHourlyTemps = [String]()
        var allHourlyTempsIcons = [String]()
        let current_ = Current()
        let currentLocation : CLLocation!
        currentLocation = locationManager.location
        let correctLocation = location.replacingOccurrences(of: " ", with: "%20")
        let urlString = (location == "Current location") ? "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(String(describing: currentLocation.coordinate.latitude)),\(String(describing: currentLocation.coordinate.longitude))&days=7" : "https://api.apixu.com/v1/forecast.json?key=ef0ae6ee03be447ba2f215216180405&q=\(correctLocation)&days=7"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
                guard error == nil else {
                    print("returned error")
                    return
                }
                guard let data = data else { return }
                guard let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                        print("Not containing JSON")
                        return
                    }
            
            guard let current = json["current"] as?  [String : AnyObject] else {return}
                current_.temp = current["temp_c"] as? Double
                current_.datetime = current["last_updated"] as? String
                guard let condition = current["condition"] as? [String : AnyObject] else {return}
                current_.condition = condition["text"] as? String
                current_.iconURL = condition["icon"] as? String
                current_.feelslike = current["feelslike_c"] as? Double
                current_.wind_dir = current["wind_dir"] as? String
                current_.wind_speed = current["wind_kph"] as? Double
                current_.wind_speed = round(current_.wind_speed! * 5/18)
                guard let forecast = json["forecast"] as? [String: AnyObject] else {return}
                let forecastday = forecast["forecastday"] as! [AnyObject]
                var allDays = [ForecastDay]()
                for index in 0...6 {
                    guard let day1 = forecastday[index] as? [String : AnyObject] else {return}
                    var allhoursForDay = [AnyObject]()
                    // Поля для forecastday
                    guard let day = day1["day"] as? [String : AnyObject] else {return}
                    let date_ = day1["date"] as? String
                    if index == 0 {
                        allDates.append("Today\n\(convertDateFormaterForDailyForecastForDate(date_!))")
                    } else {
                        allDates.append("\(convertDateFormaterForDailyForecastForDateDescription(date_!))\n\(convertDateFormaterForDailyForecastForDate(date_!))")
                    }
                    let comment_ = ""
                    guard let maxtemp_ = day["maxtemp_c"] as? Double else {return}
                    guard let mintemp_ = day["mintemp_c"] as? Double else {return}
                    guard let avgtemp_ = day["avgtemp_c"] as? Double else {return}
                    guard var wind_max_ = day["maxwind_kph"] as? Double? else {return}
                    wind_max_ = (wind_max_!) * 5/18
                    guard let avghum_ = day["avghumidity"] as? Double else {return}
                    guard let uv_ = day["uv"] as? Double else {return}
                    guard let text = day["condition"] as? [String: AnyObject] else {return}
                    guard let condition_ = text["text"] as? String else {return}
                    guard let iconUrl  = text["icon"] as? String else {return}
                    allTempsdaysIcons.append("https:" + iconUrl)
                    guard let hoursArr = day1["hour"] as? [AnyObject] else {return}
                    var counter = 24 // days
                    for object in hoursArr {
                        if counter>0 {
                            let newHour = ForecastHour()
                            guard let time = object["time"] as? String else {return}
                            var timeArr = time.split(separator: " ")
                            newHour.time = String(timeArr[1])
                            newHour.feelslike = object["feelslike_c"] as? Double
                            newHour.humidity = object["humidity"] as? Double
                            newHour.pressure = object["pressure_mb"] as? Double
                            guard let text = object["condition"] as? [String : AnyObject] else {return}
                            newHour.condition = text["text"] as? String
                            newHour.icon = text["icon"] as? String
                            
                            newHour.temperature = object["temp_c"] as? Double
                            newHour.chance_of_rain = object["chance_of_rain"] as? String
                            newHour.will_it_rain = object["will_it_rain"] as? Int
                            newHour.will_it_snow = object["will_it_snow"] as? Int
                            allhoursForDay.append(newHour)
                            counter -= 1
                        }
                    }
                    let newDay = ForecastDay(avg_temp_c: avgtemp_, date: date_!,temperature_avg: avgtemp_, temperature_max: maxtemp_, temperature_min: mintemp_, windSpeed_max: wind_max_!, iconURL: iconUrl, avghumidity: avghum_, comment: comment_, condition: condition_, uv: uv_, forecastHours: allhoursForDay as! [ForecastHour])
                    allTempsdays.append("\(Int(round(newDay.AllHours![12].temperature!)))°  \(Int(round(newDay.AllHours![0].temperature!)))°")
                    newDay.date = date_!
                    allDays.append(newDay)
                }
                self.allDates = allDates
                self.allTemps = allTempsdays
                self.allTempsIcons = allTempsdaysIcons
            
                if (self.hour) > 12 {
                    for i in (self.hour)..<24 {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                        allHourlyTempsIcons.append("https:" + allDays[0].AllHours![i].icon!)
                    }
                    if 24-(self.hour) < 12 {
                        for i in 0...12-(24-(self.hour)) {
                            allHours.append("\(i):00")
                            allHourlyTemps.append("\(String(describing: Int(round(allDays[1].AllHours![i].temperature!))))°C")
                            allHourlyTempsIcons.append("https:" + allDays[1].AllHours![i].icon!)
                        }
                    }
                } else {
                    for i in (self.hour)...(self.hour)+12 {
                        allHours.append("\(i):00")
                        allHourlyTemps.append("\(String(describing: Int(round(allDays[0].AllHours![i].temperature!))))°C")
                        allHourlyTempsIcons.append("https:" + allDays[0].AllHours![i].icon!)
                    }
                }
                self.allHours = allHours
                self.allHourlyTemps = allHourlyTemps
                self.allHourlyTempsIcons = allHourlyTempsIcons
                self.currentForecastCity = ForecastCity(Current: current_, ForecastDay: allDays)
                DispatchQueue.main.async {
                        self.forecastTableView.reloadData()
                        self.forecastCollectionView.reloadData()
                        self.currentLocation.attributedText = NSMutableAttributedString(string: location, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 18)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self.currentTemperature.attributedText = NSMutableAttributedString(string: String(Int(round(current_.temp!))) + "°C", attributes: [NSAttributedStringKey.font:UIFont.init(name: "SFProDisplay-Light", size: 80)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        self.currentCondition.attributedText = NSMutableAttributedString(string: current_.condition!, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 30)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])
                        let methods = Methods()
                        let forecastday_ = self.currentForecastCity.AllForecastDay![0]
                        var comment = methods.GetCurrentComment(Current : current_)
                        comment += methods.GetThunderComment(forecastday: forecastday_)
                        self.currentAdvice.attributedText = NSMutableAttributedString(string: comment, attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Medium", size: 15)!, NSAttributedStringKey.foregroundColor:UIColor(white: 1, alpha: 0.9)])

                }
                }.resume()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func UpdateFavourits() {
        self.favouriteCitiesTableView.reloadData()
    }
    
    @objc func ClosingSearchVC() {
        self.forecastTableView.isUserInteractionEnabled = true
        self.forecastCollectionView.isUserInteractionEnabled = true
        self.searchButton.isUserInteractionEnabled = true
        self.bottomStackView.isUserInteractionEnabled = true
        self.topStackView.isUserInteractionEnabled = true
        self.middleStackView.isUserInteractionEnabled = true
        self.currentTemperature.isUserInteractionEnabled = true
        self.currentCondition.isUserInteractionEnabled = true
        self.currentAdvice.isUserInteractionEnabled = true
        self.currentLocation.isUserInteractionEnabled = true
        self.searchButton.isEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = nil
        }
        self.blurEffectView.isHidden = true // Нужно улучшить, потому что колхоз
    }
    
    private let weaLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.attributedText = NSAttributedString(string: "Wea", attributes: [NSAttributedStringKey.font: UIFont.init(name: "SFProDisplay-Bold", size: 75)!])
        text.backgroundColor = UIColor(white: 1, alpha: 0.8)
        text.layer.shadowColor = UIColor.white.cgColor
        text.layer.shadowOpacity = 1
        text.layer.shadowOffset = CGSize.zero
        text.layer.shadowRadius = 30
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.backgroundColor = .lightBlue
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateFavourits), name: NSNotification.Name(rawValue: "upF"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ClosingSearchVC), name: NSNotification.Name(rawValue: "closeSVC"), object: nil)
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingHeading()
        }
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        favouriteCitiesTableView.delegate = self
        favouriteCitiesTableView.dataSource = self
        forecastCollectionView.dataSource = self
        forecastTableView.register(DayCell.self, forCellReuseIdentifier: "tableViewcell")
        forecastCollectionView.register(HourCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        LayOut()
        view.addSubview(splashScreen)
        
        splashScreen.addSubview(theLabel)
        splashScreen.addSubview(weaLabel)
        splashScreen.addSubview(rLabel)
        
        weaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        weaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive = true
        theLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        theLabel.leadingAnchor.constraint(equalTo: weaLabel.trailingAnchor).isActive = true
        rLabel.leadingAnchor.constraint(equalTo: theLabel.trailingAnchor).isActive = true
        rLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        splashScreen.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        splashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        splashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        splashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Animation), userInfo: nil, repeats: false)
        Animate()
        UpdateInfo(location: "Current location")
    }
    
    private func Animate() {
        self.theLabel.frame.origin.x = 0
        self.weaLabel.frame.origin.x = 0
        UIView.animate(withDuration: 3, delay: 0.25, options: [.autoreverse, .repeat], animations: {
            self.theLabel.frame.origin.x += 155
            self.weaLabel.frame.origin.x -= 100
        })
    }
    
    @objc private func Animation() {
            UIView.animate(withDuration: 1, animations: {
                self.splashScreen.alpha = 0
                self.weaLabel.alpha = 0
                self.theLabel.alpha = 0
                self.rLabel.alpha = 0
                
            })
        self.splashScreen.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

