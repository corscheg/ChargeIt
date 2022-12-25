//
//  AuthRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// Router of the Auth module.
final class AuthRouter {
    
    // MARK: VIPER
    weak var view: AuthViewProtocol?
}

// MARK: - AuthRouterProtocol
extension AuthRouter: AuthRouterProtocol {
    
}
