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
    
    var models = [DailyWeatherEntry]()
    var hourlyModels = [HourlyWeatherEntry]()
    var cityHeader: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavigationBar()
        setupHourlyTableView()
        setupDaysTableView()
        
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
        //Open Search View Controller action
        locationButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
    }
    //Open Search View Controller
    @objc func buttonClicked() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewControllerID") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    // Table
    
    func setupTableView() {
        mainTable.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
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
            guard let result = json else { return }
            let entries = result.daily.data
            self.models.append(contentsOf: entries)
            self.hourlyModels = result.hourly.data
            
            //Update user interface
            DispatchQueue.main.async {

                self.mainTable.reloadData()
//                let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//                self.mainTable.tableHeaderView = headerVIew
            }
        }).resume()
    }
    

}
// Table
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        if section == 0 {
            return 1
        }
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Hour Cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            
            return cell
        }
        // DayCell
        let cell = tableView.dequeueReusableCell(withIdentifier: DaysTableViewCell.identifier, for: indexPath) as! DaysTableViewCell
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 155
        } else {
            return 50
        }
    }
}

