//
//  SettingsViewProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// A protocol of the Settings module view.
protocol SettingsViewProtocol: AnyObject {
    
    /// Present the dialog for deletion confirmation.
    func presentConfirmationDialog()
    
    /// Show a success alert with the given message.
    func showSuccessAlert(with message: String?)
    
    /// Show an error alert with the given message.
    func showErrorAlert(with message: String?)
    
    /// Hide the presented alert.
    func hideAlert()
}
