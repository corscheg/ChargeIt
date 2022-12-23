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
    let uuid: UUID
    let id: Int
    let location: LocationInfo
    let connections: [Connection]
    let mediaItems: [MediaItem]?
}

// MARK: - Codable
extension ChargingPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case uuid = "UUID"
        case id = "ID"
        case location = "AddressInfo"
        case connections = "Connections"
        case mediaItems = "MediaItems"
    }
}

// MARK: - Hashable
extension ChargingPoint: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
    
    static func ==(lhs: ChargingPoint, rhs: ChargingPoint) -> Bool {
        lhs.location == rhs.location
    }
}
