//
//  DetailPointInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module interactor.
protocol DetailPointInteractorProtocol {
    
    /// Fetch images and callback the presenter on each loaded photo.
    func fetchPhotos(with urls: [URL])
    
    /// Check if a point with the given UUID is favorite.
    func isFavorite(by id: UUID) -> Bool
    
    /// Add a point to favorites.
    func addToFavorites(_ point: DetailPointViewModel)
    
    /// Remove the point with the given id from favorites.
    func removeFromFavorites(by id: UUID)
}
