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
    var models = [MainStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=47.81&lon=35.18&units=metric&appid=045e4e83c9704ff8430809b1f0b7f377"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, responds, error in
            guard let data = data, error == nil else {
                print("Something went wrong")
               
                return
            }
        })
        
        setupHourlyTableView()
        setupDaysTableView()
        
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
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
}
