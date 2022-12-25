//
//  Credentials.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// A struct representing data necessary to authenticate the user.
struct Credentials {
    let email: String
    let password: String
}

// MARK: - Codable
extension Credentials: Codable {
    enum CodingKeys: String, CodingKey {
        case email = "emailaddress"
        case password
    }
}
