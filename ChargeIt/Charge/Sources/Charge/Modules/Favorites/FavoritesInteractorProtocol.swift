//
//  FavoritesInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// A protocol of the Favorites module interactor.
protocol FavoritesInteractorProtocol {
    
    /// Get all favorite points.
    func allFavorites() throws -> [PointObj]
}
