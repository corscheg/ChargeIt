//
//  SettingsViewProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// A protocol of the Settings module view.
protocol SettingsViewProtocol: AnyObject {
    
    /// Update the UI with the given View Model.
    func updateUI(with viewModel: SettingsViewModel)
    
    /// Present the dialog for deletion confirmation.
    func presentConfirmationDialog()
    
    /// Show a success alert with the given message.
    func showSuccessAlert(with message: String?)
    
    /// Show an error alert with the given message.
    func showErrorAlert(with message: String?)
}
