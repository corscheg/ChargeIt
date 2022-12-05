//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import MapKit

protocol SearchPresenterProtocol: AnyObject {
    func loadState()
    func radiusChanged(value: Float)
    func mapRegionChanged(to: MKCoordinateRegion)
    func loadNearbyPoints()
    func pointsLoadingFailed(with error: SearchError)
    func pointsLoadingSucceeded(with points: [ChargingPoint])
    func enableLocation()
    func disableLocation()
}
