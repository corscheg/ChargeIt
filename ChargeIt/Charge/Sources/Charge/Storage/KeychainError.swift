//
//  KeychainError.swift
//  
//
//  Created by Александр Казак-Казакевич on 25.12.2022.
//

import Foundation

enum KeychainError: Error {
    case unknown(OSStatus?)
}

// MARK: - LocalizedError
extension KeychainError: LocalizedError {
    var errorDescription: String? {
        return "Password storage error"
    }
}
