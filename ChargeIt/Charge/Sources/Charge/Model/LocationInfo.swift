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
    let country: Country
    let state: String?
    let town: String?
    let addressFirst: String?
    let addressSecond: String?
    let title: String?
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
        case country = "Country"
        case state = "StateOrProvince"
        case town = "Town"
        case addressFirst = "AddressLine1"
        case addressSecond = "AddressLine2"
        case title = "Title"
    }
}

// MARK: - Country
extension LocationInfo {
    struct Country: Codable {
        
        // MARK: Public Properties
        let code: String
        let title: String?
        
        // MARK: CodingKeys
        enum CodingKeys: String, CodingKey {
            case code = "ISOCode"
            case title = "Title"
        }
    }
}
