//
//  MainViewController.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 14.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    @IBOutlet var mainTable: UITableView!
    
    let daysTVCell = DaysTableViewCell()
    var models = [DailyWeatherEntry]()
    var hourlyModels = [HourlyWeatherEntry]()
    var current: CurrentWeather?
    var selectedIndexPath = IndexPath(item: 0, section: 2)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        setupNavigationBar()
        setupHourlyTableView()
        setupDaysTableView()
        setupHeaderTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        request()
    }
    
    func setupView() {
        
        self.view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }
    
    func setupNavigationBar () {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        setupLeftNavBarItems()
    }
    
    func setupLeftNavBarItems() {
        
        let locationButton = UIButton(type: .system)
        locationButton.setImage(#imageLiteral(resourceName: "ic_place").withRenderingMode(.alwaysOriginal) , for: .normal)
        locationButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationButton)
        
        let cityLabel = UILabel()
        cityLabel.text = "\(PositionManager.sharedInstance.currentCity)"
        cityLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cityLabel.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: locationButton), UIBarButtonItem(customView: cityLabel)]
        // Open Search View Controller action
        locationButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
    }
    
    // Open Search View Controller
    @objc func buttonClicked() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewControllerID") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupTableView() {
        
        mainTable.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }
    
    func setupHeaderTableView() {
        
        // Register cell
        mainTable.register(HeaderTableViewCell.nib(), forCellReuseIdentifier: HeaderTableViewCell.identifier)
    }
    func setupHourlyTableView() {
        
        // Register cell
        mainTable.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    }
    func setupDaysTableView() {
        
        // Register cell
        mainTable.register(DaysTableViewCell.nib(), forCellReuseIdentifier: DaysTableViewCell.identifier)
    }
    
    // URL Session
    func request() {
        
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(PositionManager.sharedInstance.currentPosition.coordinate.latitude),\(PositionManager.sharedInstance.currentPosition.coordinate.longitude)?units=si&exclude=[flags,minutely]"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, responds, error in
            guard let data = data, error == nil else {
                print("Something went wrong")
                
                return
            }
            
            var json: WeatherResponse?
            
            do {
                
                json = try JSONDecoder().decode(WeatherResponse .self, from: data)
            }
                
            catch {
                
                print("error: \(error)")
            }
            
            guard let result = json else {
                
                return
            }
            
            let entries = result.daily.data
            self.models.append(contentsOf: entries)
            self.hourlyModels = result.hourly.data
            let current = result.currently
            self.current = current
            
            // Update user interface
            DispatchQueue.main.async {
                
                self.mainTable.reloadData()
            }
            
        })
            .resume()
    }
    
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "E, dd MMM"
        
        return formatter.string(from: inputDate).uppercased()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none
        // Header section
        if section == 0 {
            
            return 1
        }
        // Hour section
        if section == 1 {
            
            return 1
        }
        // Day section
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Header section
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier, for: indexPath) as! HeaderTableViewCell
            guard let currentWeather = self.current else {
                
                return cell
            }
            
            cell.dayLabelll.text = getDayForDate(Date(timeIntervalSince1970: Double(models[selectedIndexPath.row].time)))
            cell.minMaxTempLabelll.text = "\(Int(models[selectedIndexPath.row].temperatureMax))° / \(Int(models[selectedIndexPath.row].temperatureMin))°"
            cell.humidityLabel.text = "\(Int(100 * (models[selectedIndexPath.row].humidity))) %"
            cell.windLabel.text = "\(Int(models[selectedIndexPath.row].windSpeed))м/сек"
            
            if models[selectedIndexPath.row].icon.contains("clear") {
                
                cell.weatherImageView.image = UIImage(named: "ic_white_day_bright")
                
            }else if models[selectedIndexPath.row].icon.contains("cloudy") {
                
                cell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")
                
            }else {
                
                cell.weatherImageView.image = UIImage(named: "ic_white_day_rain")
            }
            
            let windSide = models[selectedIndexPath.row].windBearing
            
            switch windSide {
            case 0...29:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_n")
            case 30...60:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_ne")
            case 61...119:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_e")
            case 120...150:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_se")
            case 151...209:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_s")
            case 210...240:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_ws")
            case 241...299:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_w")
            case 300...330:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_wn")
            case 331...360:
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_n")
            default :
                cell.windSideIcon.image = #imageLiteral(resourceName: "icon_wind_n")
            }

//            cell.selectionStyle = .none
            
            return cell
        }
        
        // Hour section
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            return cell
        }
        
        // Day section
        let cell = tableView.dequeueReusableCell(withIdentifier: DaysTableViewCell.identifier, for: indexPath) as! DaysTableViewCell
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Header section
        if indexPath.section == 0 {
            
            return 160
        }
        // Hour section
        if indexPath.section == 1 {
            
            return 155
        }
        // Day section
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = mainTable.indexPathForSelectedRow ?? selectedIndexPath
        mainTable.reloadData()
    }
}

