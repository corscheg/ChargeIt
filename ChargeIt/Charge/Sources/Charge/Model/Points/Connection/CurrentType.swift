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
extension CurrentType: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - Hashable
extension CurrentType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: CurrentType, rhs: CurrentType) -> Bool {
        lhs.id == rhs.id
    }
}
