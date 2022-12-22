//
//  CheckIn.swift
//  
//
//  Created by Александр Казак-Казакевич on 22.12.2022.
//

import Foundation

/// A struct used for posting check-ins.
struct CheckIn {
    let pointID: Int
}

// MARK: - Codable
extension CheckIn: Codable { }

// MARK: - CodingKeys
extension CheckIn {
    enum CodingKeys: String, CodingKey {
        case pointID = "chargePointID"
    }
}
