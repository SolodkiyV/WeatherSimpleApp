//
//  SearchViewController.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 19.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var seatchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var placeLati = "-33.8670522"
    var placeLong = "151.1957362"
    var countryList: [String] = []
    var place: [String] =
        ["46.47747, 30.73262",
         "50.45466, 30.5238",
         "49.83826, 24.02324",
         "51.508530, -0.076132",
         "52.531677, 13.381777",
         "40.730610, -73.935242"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        
        for country in place {
            countryList.append(country)
        }
        
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
                    let range = country.lowercased().range(of: countryToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        return place.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "place")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "place")
        }
        if searchTextField.text?.count != 0 {
            cell?.textLabel?.text = place[indexPath.row]
        }else {
            cell?.textLabel?.text = ""
        }

        return cell!
    }
}

