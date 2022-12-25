//
//  AuthInteractorToPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// A protocol of the Auth module presenter for the interactor.
protocol AuthInteractorToPresenterProtocol: AnyObject {
    
    /// Notify presenter that the authentication was successful
    func authSucceeded()
    
    /// Notify presenter that the authentication failed.
    func authFailed(with error: Error)
}
