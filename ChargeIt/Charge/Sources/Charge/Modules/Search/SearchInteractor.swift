//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

class SearchInteractor {
    
    // MARK: Public Properties
    weak var presenter: SearchPresenterProtocol?
}

// MARK: - SearchInteractorProtocol
extension SearchInteractor: SearchInteractorProtocol {
    
}
