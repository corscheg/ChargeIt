//
//  DetailPointInteractor.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Interactor of the Detail Point module.
final class DetailPointInteractor {
    
    // MARK: Public Properties
    weak var presenter: DetailPointPresenterProtocol?
    
    // MARK: Private Properties
    private let dataManager: DataManager = DataManager.shared
}

// MARK: - DetailPointInteractorProtocol
extension DetailPointInteractor: DetailPointInteractorProtocol {
    
}
