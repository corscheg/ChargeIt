//
//  LocationInfo.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation
import MapKit

/// A struct representing a location.
struct LocationInfo {
    
    // MARK: Private Properties
    private let latitude: Double
    private let longitude: Double
    
    // MARK: Public Properties
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Codable
extension LocationInfo: Codable { }

// MARK: - CodingKeys
extension LocationInfo {
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}
