//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation
import CoreLocation

struct ChargingPoint {
    let id: UUID
    let location: LocationInfo
}

// MARK: - Codable
extension ChargingPoint: Codable {
    
}

// MARK: - LocationInfo
extension ChargingPoint {
    struct LocationInfo: Codable {
        private let latitude: Double
        private let longitude: Double
        
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
    }
}
