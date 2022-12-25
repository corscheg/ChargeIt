//
//  AuthInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// A protocol of the Auth module interactor.
protocol AuthInteractorProtocol {
    
    /// Authorize the user.
    func authorize(_ credentials: Credentials)
}
