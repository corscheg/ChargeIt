//
//  DetailPointPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module presenter.
protocol DetailPointPresenterProtocol: AnyObject {
    
    /// Notify presenter that view is ready for presentation.
    func viewDidLoad()
    
    /// Notify presenter that view is on the screen.
    func viewDidAppear()
    
    /// Notify presenter that favorite button was tapped.
    func favoriteButtonTapped()
    
    /// Notify presenter that Apple Maps button was tapped.
    func openMapsButtonTapped()
    
    /// Dismiss the Detail Point view.
    func dismissButtonTapped()
}
