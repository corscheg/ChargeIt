//
//  DetailPointInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module interactor.
protocol DetailPointInteractorProtocol {
    
    /// Check whether a point with the given UUID is favorite.
    func isFavorite(by id: UUID) throws -> Bool
    
    /// Post check-in.
    func checkIn(_ check: CheckIn)
}
