//
//  ChargingPoint.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation
import CoreLocation

/// A struct representing one charging point.
struct ChargingPoint {

    // MARK: Public Properties
    let id: UUID
    let location: LocationInfo
    let connections: [Connection]
}

// MARK: - Codable
extension ChargingPoint: Codable { }

// MARK: - LocationInfo
extension ChargingPoint {
    
    /// A struct representing a location.
    struct LocationInfo: Codable {
        
        // MARK: Private Properties
        private let latitude: Double
        private let longitude: Double
        
        // MARK: Public Properties
        var coordinates: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        // MARK: - CodingKeys
        enum CodingKeys: String, CodingKey {
            case latitude = "Latitude"
            case longitude = "Longitude"
        }
    }
}

// MARK: - CodingKeys
extension ChargingPoint {
    enum CodingKeys: String, CodingKey {
        case id = "UUID"
        case location = "AddressInfo"
        case connections = "Connections"
    }
}
