//
//  CheckInResponse.swift
//  
//
//  Created by Александр Казак-Казакевич on 22.12.2022.
//

import Foundation

/// A struct representing server response for the check in.
struct CheckInResponse {
    let status: String
    let description: String
}

// MARK: - Codable
extension CheckInResponse: Codable { }
