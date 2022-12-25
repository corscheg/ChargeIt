//
//  AuthViewProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import Foundation

/// A protocol of the Auth module view.
protocol AuthViewProtocol: AnyObject {
    
    /// Present a success alert with the given message.
    func showSuccessAlert(with message: String?)
    
    /// Present a failure alert with the given message.
    func showErrorAlert(with message: String?)
}
