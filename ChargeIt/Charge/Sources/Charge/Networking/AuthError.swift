//
//  AuthError.swift
//  
//
//  Created by Александр Казак-Казакевич on 25.12.2022.
//

import Foundation

enum AuthError: Error {
    case notAuthorized
}

// MARK: - LocalizedError
extension AuthError: LocalizedError {
    var errorDescription: String? {
        "User is not authenticated"
    }
}
