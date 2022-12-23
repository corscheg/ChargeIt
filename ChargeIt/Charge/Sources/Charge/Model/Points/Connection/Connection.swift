//
//  Connection.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A struct that represents a single connection.
struct Connection {
    
    // MARK: Public Properties
    let type: ConnectionType
    let level: Level?
    let currentType: CurrentType?
}

// MARK: - Codable
extension Connection: Codable {
    enum CodingKeys: String, CodingKey {
        case type = "ConnectionType"
        case level = "Level"
        case currentType = "CurrentType"
    }
}

// MARK: - Hashable
extension Connection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(level)
        hasher.combine(currentType)
    }
    
    static func ==(lhs: Connection, rhs: Connection) -> Bool {
        lhs.type == rhs.type && lhs.level == rhs.level && lhs.currentType == rhs.currentType
        
    }
}
