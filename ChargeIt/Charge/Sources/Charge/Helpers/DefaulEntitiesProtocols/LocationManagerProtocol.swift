//
//  LocationManagerProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    var delegate: CLLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
    
    func requestLocation()
    
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: LocationManagerProtocol { }
