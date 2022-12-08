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
    static func build(with point: ChargingPoint) -> DetailPointViewController {
        let interactor = DetailPointInteractor()
        let router = DetailPointRouter()
        let presenter = DetailPointPresenter(router: router, interactor: interactor, point: point)
        let view = DetailPointViewController(presenter: presenter)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}