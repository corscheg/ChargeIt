//
//  KeychainManager.swift
//  
//
//  Created by Александр Казак-Казакевич on 25.12.2022.
//

import Foundation

/// A facade for iOS Keychain service.
final class KeychainManager: KeychainManagerProtocol {
    
    // MARK: Static Properties
    static let shared = KeychainManager()
    
    // MARK: Private Properties
    let service = "openchargemap.org"
    let account = "corscheg"
    
    // MARK: Initializers
    private init() { }
    
    // MARK: Public Methods
    func save(token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.unknown(nil)
        }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func loadToken() throws -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        
        guard status != errSecItemNotFound else {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func deleteToken() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
}

