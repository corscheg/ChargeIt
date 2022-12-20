//
//  Level.swift
//  
//
//  Created by Александр Казак-Казакевич on 07.12.2022.
//

import Foundation

/// A struct representing possibility of fast charge.
struct Level {
    
    // MARK: Public Properties
    let id: Int
    let title: String
    let fastChargeCapable: Bool
}

// MARK: - Codable
extension Level: Codable { }

// MARK: - CodingKeys
extension Level {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case fastChargeCapable = "IsFastChargeCapable"
    }
}

// MARK: - Hashable
extension Level: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Level, rhs: Level) -> Bool {
        lhs.id == rhs.id
    }
}
