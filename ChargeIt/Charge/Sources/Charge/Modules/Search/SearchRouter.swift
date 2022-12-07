//
//  SearchRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation
import UIKit

/// Router of the Search module.
class SearchRouter {
    
    // MARK: Public Properties
    weak var view: SearchViewProtocol?
}

// MARK: - SearchRouterProtocol
extension SearchRouter: SearchRouterProtocol {
    func presentDetail(with point: ChargingPoint) {
        guard let uiView = view as? UIViewController else {
            return
        }
        
        let detailView = DetailPointBuilder.build(with: point)
        uiView.present(detailView, animated: true)
    }
}
