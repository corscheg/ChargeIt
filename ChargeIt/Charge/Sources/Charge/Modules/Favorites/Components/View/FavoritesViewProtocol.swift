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
    
    /// Remove the given point.
    func remove(point: DetailPointViewModel)
    
    /// Present an error alert with the given message.
    func showErrorAlert(with message: String?)
}
