//
//  SearchRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import UIKit

/// Router of the Search module.
final class SearchRouter {
    
    // MARK: VIPER
    weak var view: SearchViewProtocol?
}

// MARK: - SearchRouterProtocol
extension SearchRouter: SearchRouterProtocol {
    func presentDetail(with viewModel: DetailPointViewModel) {
        guard let uiView = view as? UIViewController else {
            return
        }
        
        let detailView = DetailPointBuilder.build(with: viewModel)
        let navigationController = UINavigationController(rootViewController: detailView)
        uiView.present(navigationController, animated: true)
    }
}
