//
//  SearchViewProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

/// A protocol of the Search module view.
protocol SearchViewProtocol: AnyObject {
    
    /// Show the activity indicator.
    func startActivityIndication()
    
    /// Hide the activity indicator.
    func stopActivityIndication()
    
    /// Update the whole UI with given View Model.
    func updateUI(with viewModel: SearchViewModel)
    
    /// Fast update the search options.
    func updateParameters(with viewModel: SearchViewModel)
    
    /// Present the given error.
    func showError(with message: String)
    
    /// Choose whether user can perform location search.
    func setLocation(enabled: Bool)
}
