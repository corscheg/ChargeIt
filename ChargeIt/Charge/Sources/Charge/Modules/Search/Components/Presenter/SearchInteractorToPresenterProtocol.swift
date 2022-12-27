//
//  SearchInteractorToPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 22.12.2022.
//

import Foundation

/// A protocol of the Search module presenter for the interactor.
protocol SearchInteractorToPresenterProtocol: AnyObject {
    
    /// Provide error to the view.
    func pointsLoadingFailed(with error: Error)
    
    /// Provide new data to the view.
    func pointsLoadingSucceeded(with points: [ChargingPoint])
    
    /// Say that location search is possible.
    func enableLocation()
    
    /// Say that location search is impossible.
    func disableLocation()
}
