//
//  MapViewController.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 14.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var anotherPlaceButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    let regionInMetters: Double  = 100000
    var countryName = ""
    var cityName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        outletsSetup()
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
            startTrackingUserLocation()
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
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        PositionManager.sharedInstance.currentPosition = getCenterLocation(for: mapView )
    }
    
    func outletsSetup() {
        anotherPlaceButton.layer.cornerRadius = 10
        anotherPlaceButton.clipsToBounds = true
        cityLabel.layer.cornerRadius = 10
        cityLabel.clipsToBounds = true
    }
    
    func getCenterLocation(for: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        PositionManager.sharedInstance.currentPosition = center
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                // SHOW ALERT INFORMATION TO USER
                return
            }
            guard let placemark = placemarks?.first else {
                // SHOW ALERT INFORMATION TO USER
                return
            }

            self.countryName = placemark.country ?? ""
            self.cityName = placemark.locality ?? ""
            
            PositionManager.sharedInstance.currentCity = placemark.locality ?? ""
            
            DispatchQueue.main.async {
                self.cityLabel.text = "\(self.cityName), \(self.countryName)"

            }
        }
    }
}

