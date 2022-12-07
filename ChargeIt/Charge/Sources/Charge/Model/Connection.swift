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
extension Connection: Codable { }

// MARK: - CodingKeys
extension Connection {
    enum CodingKeys: String, CodingKey {
        case type = "ConnectionType"
        case level = "Level"
        case currentType = "CurrentType"
    }
}
