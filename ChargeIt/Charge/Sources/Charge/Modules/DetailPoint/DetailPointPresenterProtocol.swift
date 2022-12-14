//
//  DetailPointPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module presenter.
protocol DetailPointPresenterProtocol: AnyObject {
    
    /// Update the view according to the current ViewModel.
    func viewDidLoad()
    
    /// Number of available connections.
    var numberOfConnections: Int { get }
    
    /// A connection View Model at the given index.
    func connection(at index: Int) -> DetailPointViewModel.ConnectionViewModel
    
    /// Notify presenter that favorite button was tapped.
    func favoriteButtonTapped()
    
    /// Notify presenter that Apple Maps button was tapped.
    func openMapsButtonTapped()
}
