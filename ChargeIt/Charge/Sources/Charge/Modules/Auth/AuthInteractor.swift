//
//  AuthInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// Interactor of the Auth module.
final class AuthInteractor {
    
    // MARK: VIPER
    weak var presenter: AuthInteractorToPresenterProtocol?
}

// MARK: - AuthInteractorProtocol
extension AuthInteractor: AuthInteractorProtocol {
    
}
