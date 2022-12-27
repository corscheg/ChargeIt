//
//  AuthViewToPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// A protocol of the Auth module presenter for the view.
protocol AuthViewToPresenterProtocol {
    
    /// Notify presenter that the email field value was changed.
    func emailChanged(to value: String)
    
    /// Notify presenter that the password field value was changed.
    func passwordChanged(to value: String)
    
    /// Notify presenter that the auth button was tapped.
    func authTapped()
    
    /// Notify presenter that the dismiss button was tapped.
    func dismissTapped()
}
