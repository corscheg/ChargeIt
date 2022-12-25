//
//  AuthResponse.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// A struct for receiving the authentication response.
struct AuthResponse {
    let tokenWrapper: TokenWrapper
}

// MARK: - TokenWrapper
extension AuthResponse {
    struct TokenWrapper: Codable {
        let token: String
        
        enum CodingKeys: String, CodingKey {
            case token = "access_token"
        }
    }
}

// MARK: - Codable
extension AuthResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case tokenWrapper = "Data"
    }
}
