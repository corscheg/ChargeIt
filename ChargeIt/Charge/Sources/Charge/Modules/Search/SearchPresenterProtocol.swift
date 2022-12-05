//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func loadNearbyPoints(with options: SearchQueryParameters)
    func pointsLoadingFailed(with error: SearchError)
    func pointsLoadingSucceeded(with points: [ChargingPoint])
    func enableLocation()
    func disableLocation()
}
