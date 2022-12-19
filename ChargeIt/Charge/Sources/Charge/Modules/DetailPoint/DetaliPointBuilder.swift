//
//  DetailPointBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Use this struct to build the Detail Point module.
struct DetailPointBuilder {
    
    // MARK: Static Methods
    /// Build the module.
    static func build(with viewModel: DetailPointViewModel) -> DetailPointViewController {
        let interactor = DetailPointInteractor()
        let router = DetailPointRouter()
        let presenter = DetailPointPresenter(router: router, interactor: interactor, viewModel: viewModel)
        let view = DetailPointViewController(presenter: presenter, dataSource: DetailPointConnectionsDataSource())
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
