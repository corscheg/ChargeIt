//
//  ConnectionType.swift
//  
//
//  Created by Александр Казак-Казакевич on 07.12.2022.
//

import Foundation

/// A struct that represents a connector type.
struct ConnectionType {
    
    // MARK: Public Properties
    let id: Int
    let title: String
    let formalName: String?
    let discontinued: Bool?
    let obsolete: Bool?
}

// MARK: - Codable
extension ConnectionType: Codable { }

// MARK: CodingKeys
extension ConnectionType {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case formalName = "FormalName"
        case discontinued = "IsDiscontinued"
        case obsolete = "IsObsolete"
    }
}
