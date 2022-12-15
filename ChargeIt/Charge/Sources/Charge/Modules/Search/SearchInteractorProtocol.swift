//
//  SearchInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import CoreData

/// A protocol of the Search module interactor.
protocol SearchInteractorProtocol {
    
    /// Load the closest charging points with the given options and provide the callback to presenter.
    func loadNearbyPoints(with options: QueryParametersViewModel)
    
    /// Add the given point to the persistent storage.
    func store(point: ChargingPoint) throws
    
    /// Remove a point with the given ID from the persistent storage.
    @discardableResult
    func delete(by id: UUID) throws -> Bool
    
    /// Determine whether a point with the given ID is stored in the persistent storage.
    func isFavorite(by id: UUID) throws -> Bool
}
