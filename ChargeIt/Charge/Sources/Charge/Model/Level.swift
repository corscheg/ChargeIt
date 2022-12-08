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

// MARK: - CustomStringConvertible
extension Level: CustomStringConvertible {
    var description: String {
        "Level: \(title), Fast Charge \(fastChargeCapable ? "" : "in")capable"
    }
}
