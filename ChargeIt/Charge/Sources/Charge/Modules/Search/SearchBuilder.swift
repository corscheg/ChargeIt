//
//  SearchBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

/// Use this struct to build the Search module.
struct SearchBuilder {
    
    // MARK: Static Methods
    /// Build the module.
    static func build() -> SearchViewController {
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let presenter = SearchPresenter(router: router, interactor: interactor)
        let view = SearchViewController(presenter: presenter)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}