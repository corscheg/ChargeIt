//
//  DetailPointRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// Router of the Detail Point search module.
final class DetailPointRouter {
    
    // MARK: Public Properties
    weak var view: DetailPointViewProtocol?
}

// MARK: - DetailPointRouterProtocol
extension DetailPointRouter: DetailPointRouterProtocol {
    
}
