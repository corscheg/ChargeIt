//
//  FavoritesRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import UIKit

/// Router of the Favorites module.
final class FavoritesRouter {
    
    // MARK: VIPER
    weak var view: FavoritesViewProtocol?
}

// MARK: - FavoritesRouterProtocol
extension FavoritesRouter: FavoritesRouterProtocol {
    func revealDetail(with viewModel: DetailPointViewModel) {
        guard let uiView = view as? UIViewController else {
            return
        }
        
        let detailView = DetailPointBuilder.build(with: viewModel)
        uiView.navigationController?.pushViewController(detailView, animated: true)
    }
}
