//
//  SearchRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

/// Router of the Search module.
class SearchRouter {
    
    // MARK: Public Properties
    weak var view: SearchViewProtocol?
}

// MARK: - SearchRouterProtocol
extension SearchRouter: SearchRouterProtocol {
    
}
