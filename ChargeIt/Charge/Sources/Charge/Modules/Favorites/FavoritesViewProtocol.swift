//
//  FavoritesViewProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// A protocol of the Favorites module view.
protocol FavoritesViewProtocol: AnyObject {
    
    /// Update the view with the given points.
    func set(points: [DetailPointViewModel])
    
    /// Present an alert with the given message.
    func showAlert(with message: String)
}
