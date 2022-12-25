//
//  AuthPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// Presenter of the Auth module.
final class AuthPresenter {
    
    // MARK: VIPER
    private let interactor: AuthInteractorProtocol
    private let router: AuthRouterProtocol
    weak var view: AuthViewProtocol?
    
    // MARK: Initializers
    init(interactor: AuthInteractorProtocol, router: AuthRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - AuthViewToPresenterProtocol
extension AuthPresenter: AuthViewToPresenterProtocol {
    
}

// MARK: - AuthInteractorToPresenterProtocol
extension AuthPresenter: AuthInteractorToPresenterProtocol {
    
}
