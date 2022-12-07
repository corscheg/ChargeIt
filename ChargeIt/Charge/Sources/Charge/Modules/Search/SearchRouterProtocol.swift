//
//  SearchRouterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

/// A protocol of the Search module router.
protocol SearchRouterProtocol {
    
    /// Present the Detail Point view with the given point.
    func presentDetail(with point: ChargingPoint)
}
