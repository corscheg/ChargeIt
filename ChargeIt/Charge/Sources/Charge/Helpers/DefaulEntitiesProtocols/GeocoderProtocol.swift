//
//  GeocoderProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import CoreLocation

protocol GeocoderProtocol {
    func reverseGeocodeLocation(_ location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler)
}

extension CLGeocoder: GeocoderProtocol { }
