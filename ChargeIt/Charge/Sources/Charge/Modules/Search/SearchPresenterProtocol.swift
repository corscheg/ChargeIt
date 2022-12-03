//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func loadPoints()
    func pointsLoadingFailed(with error: Error)
    func pointsLoadingSucceeded(with points: [ChargingPoint])
}
