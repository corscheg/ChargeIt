//
//  FavoritesRouterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// A protocol of the Favorites module router.
protocol FavoritesRouterProtocol {
    
    /// Show the Detail Point view.
    func revealDetail(with viewModel: DetailPointViewModel)
}
