//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

struct SearchBuilder {
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
