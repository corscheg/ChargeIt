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

// MARK: - CodingKeys
extension ChargingPoint {
    enum CodingKeys: String, CodingKey {
        case id = "UUID"
        case location = "AddressInfo"
        case connections = "Connections"
    }
}

// MARK: CustomStringConvertible
extension ChargingPoint: CustomStringConvertible {
    var description: String {
        var connectionsString = "Connections: \n"
        for connection in connections {
            connectionsString.append("    " + connection.description + "\n")
        }
        return """
        Latitude: \(location.coordinates.latitude)
        Longitude: \(location.coordinates.longitude)
        \(connectionsString)
        """
    }
}
