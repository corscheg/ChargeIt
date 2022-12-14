//
//  LocationInfo.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A struct representing a location.
struct LocationInfo {
    
    // MARK: Public Properties
    let country: Country
    let state: String?
    let town: String?
    let addressFirst: String?
    let addressSecond: String?
    let title: String?
    let latitude: Double
    let longitude: Double
}

// MARK: - Codable
extension LocationInfo: Codable {
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

// MARK: - Hashable
extension LocationInfo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(title)
    }
    
    static func ==(lhs: LocationInfo, rhs: LocationInfo) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.title == rhs.title
    }
}
