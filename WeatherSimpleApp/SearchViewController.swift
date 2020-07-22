//
//  SearchViewController.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 19.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {

    @IBOutlet weak var seatchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchItem: UIBarButtonItem!
    
    let countryList: [[String: Any]] =
        [
            ["city": "Одесса, Украина", "latitude": 46.47747, "longitude": 30.73262],
            ["city": "Киев, Украина", "latitude": 50.45466, "longitude": 30.5238],
            ["city": "Львов, Украина", "latitude": 49.83826, "longitude": 24.02324],
            ["city": "Лондон, Англия", "latitude": 51.508530, "longitude": -0.076132],
            ["city": "Берлин, Германия", "latitude": 52.531677, "longitude": 13.381777],
            ["city": "Париж, Франция", "latitude": 48.864716, "longitude": 2.349014]
       ]

    var place = [[String: Any]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        
        searchTextField.delegate = self
        seatchTableView.delegate = self
        seatchTableView.dataSource = self
        
        searchTextField.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
    }
    
    @objc func searchRecords(_ textField: UITextField) {
        
        self.place.removeAll()
        
        if textField.text?.count != 0 {
            
            for country in countryList {
                
                if let countryToSearch = textField.text {
                    
                    if let city = country["city"] as? String, let _ = city.lowercased().range(of: countryToSearch, options: .caseInsensitive, range: nil, locale: nil) {
                        
                        self.place.append(country)
                    }
                }
            }
        }else {
            
            for country in countryList {
                place.append(country)
            }
        }
        seatchTableView.reloadData()
    }
}

extension SearchViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none
        return place.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let placeDict = place[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "place")
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "place")
        }
        
        if searchTextField.text?.count != 0, let city = placeDict["city"] as? String {
            
            cell?.textLabel?.text = city
        }else {
            
            cell?.textLabel?.text = ""
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placeDict = place[indexPath.row]
        
        guard let latitude = placeDict["latitude"] as? Double, let longitude = placeDict["longitude"] as? Double else {
            
            return
        }
        
        PositionManager.sharedInstance.currentPosition = CLLocation.init(latitude: latitude, longitude: longitude)
        
        guard let cityCountry = placeDict["city"] as? String else {
            
            return
        }
        let result: [String] =  cityCountry.components(separatedBy: [","])
        
        PositionManager.sharedInstance.currentCity = result[0]
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToMainView", sender: self)
    }
}
