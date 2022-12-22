//
//  DetailPointViewProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module view.
protocol DetailPointViewProtocol: AnyObject {
    
    /// Update UI with the given ViewModel.
    func updateUI(with viewModel: DetailPointViewModel)
    
    /// Set the favorite button to the appropriate state.
    func setFavorite(state: Bool)
    
    /// Show an alert with the given message.
    func showAlert(with message: String)
    
    /// Present the activity indicator.
    func startActivityIndication()
    
    /// Hide the activity indicator.
    func stopActivityIndication()
}
