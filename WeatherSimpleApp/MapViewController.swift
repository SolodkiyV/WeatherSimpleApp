//
//  MapViewController.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 14.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//
//искать только города.
//let filter = GMSAutocompleteFilter()
//filter.type = GMSPlacesAutocompleteTypeFilter.City

//Как говорит @Disco S2, добавьте экземпляр MKMapView в качестве подсмотра к вашему представлению. Чтобы узнать, где ваш пользователь нажал на карте, используйте этот метод:
//- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMetters: Double  = 50000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAutorization()
        }else {
            // Show allert to turn on locationServices
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMetters, longitudinalMeters: regionInMetters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
}

