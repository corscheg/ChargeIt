//
//  CurrentType.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A struct that represents the type of connection current.
struct CurrentType {
    
    // MARK: Public Properties
    let id: Int
    let title: String
}

// MARK: - Codable
extension CurrentType: Codable { }

// MARK: CodingKeys
extension CurrentType {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
    }
}

// MARK: CustomStringConvertible
extension CurrentType: CustomStringConvertible {
    var description: String {
        "Current: \(title)"
    }
}
