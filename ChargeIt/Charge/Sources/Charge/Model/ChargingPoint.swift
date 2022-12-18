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
    let mediaItems: [MediaItem]?
}

// MARK: - Codable
extension ChargingPoint: Codable { }

// MARK: - CodingKeys
extension ChargingPoint {
    enum CodingKeys: String, CodingKey {
        case id = "UUID"
        case location = "AddressInfo"
        case connections = "Connections"
        case mediaItems = "MediaItems"
    }
}

// MARK: - CustomStringConvertible
extension ChargingPoint: CustomStringConvertible {
    var description: String {
        var connectionsString = "Connections: \n"
        for connection in connections {
            connectionsString.append("    " + connection.description + "\n")
        }
        return """
        Title: \(location.title ?? "Unknown")
        Latitude: \(location.coordinates.latitude)
        Longitude: \(location.coordinates.longitude)
        \(connectionsString)
        """
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
