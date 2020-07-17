//
//  MainViewController.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 14.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var mainTable: UITableView!
    
    let location = MapViewController()
    var models = [DailyWeatherEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHourlyTableView()
        setupDaysTableView()
        request()
        print(models)
    }
    // URL Session
    func request() {
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/47.784243,35.18404?units=si&exclude=[flags,minutely]"
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
    
            //Update user interface
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        }).resume()
    }
    // Table
    func setupHourlyTableView() {
        // Register cell
        mainTable.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    }
    
    func setupDaysTableView() {
        // Register cell
        mainTable.register(DaysTableViewCell.nib(), forCellReuseIdentifier: DaysTableViewCell.identifier)
    }
    
}
// Table
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        // blur
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        tableView.backgroundView = blurEffectView
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DaysTableViewCell.identifier, for: indexPath) as! DaysTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
}
