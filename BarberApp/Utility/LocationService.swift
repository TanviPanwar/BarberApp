//
//  LocationService.swift
//  BarberApp
//
//  Created by GD3 on 5/13/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationService: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var lat:Double = 0.0,long:Double = 0.0
    static let sharedInstance =  LocationService()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom:1)
        
        
        lat = (location?.coordinate.latitude)!
        long = (location?.coordinate.longitude)!
        
        
    }
    
    func getCurrentLatitudeAnfLongitude() -> (lat:Double,long:Double) {
        return (lat,long)
    }
}
