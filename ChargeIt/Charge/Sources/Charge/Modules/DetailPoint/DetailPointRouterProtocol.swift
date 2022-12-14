//
//  DetailPointRouterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module router.
protocol DetailPointRouterProtocol {
    
    /// Reveal the given point in Apple Maps app.
    func openInMaps(latitude: Double, longitude: Double)
    
    /// Dismiss the Detail Point view.
    func dismiss()
}
