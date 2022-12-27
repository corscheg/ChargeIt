//
//  SearchInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

/// A protocol of the Search module interactor.
protocol SearchInteractorProtocol {
    
    /// Load the closest charging points with the given options and provide the callback to presenter.
    func loadNearbyPoints(with options: QueryParameters)
    
    /// Add the given point to the persistent storage.
    func store(point: ChargingPoint) throws
    
    /// Remove a point with the given ID from the persistent storage.
    func delete(by id: UUID) throws
}
