//
//  KeychainManagerProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 25.12.2022.
//

import Foundation

protocol KeychainManagerProtocol {
    func save(token: String) throws
    
    func loadToken() throws -> String?
    
    func deleteToken() throws
}
