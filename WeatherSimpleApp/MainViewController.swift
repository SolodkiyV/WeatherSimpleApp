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
    
    var models = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

struct Weather {
    
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
