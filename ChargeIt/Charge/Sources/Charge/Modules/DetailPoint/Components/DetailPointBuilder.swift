//
//  DetailPointBuilder.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import UIKit

/// Use this struct to build the Detail Point module.
struct DetailPointBuilder {
    
    // MARK: Static Methods
    /// Build the module.
    static func build(with viewModel: DetailPointViewModel) -> DetailPointViewController {
        let storageManager = StorageManager.shared
        let networkManager = NetworkManager.shared
        let keychainManager = KeychainManager.shared
        let hapticsGenerator = UINotificationFeedbackGenerator()
        
        let interactor = DetailPointInteractor(storageManager: storageManager, networkManager: networkManager, keychainManager: keychainManager)
        let router = DetailPointRouter()
        let presenter = DetailPointPresenter(router: router, interactor: interactor, viewModel: viewModel)
        let view = DetailPointViewController(presenter: presenter, hapticsGenerator: hapticsGenerator)
        
        presenter.view = view
        router.view = view
        interactor.presenter = presenter
        
        return view
    }
}
