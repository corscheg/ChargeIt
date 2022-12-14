//
//  DetailPointRouter.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation
import UIKit

/// Router of the Detail Point search module.
final class DetailPointRouter {
    
    // MARK: Public Properties
    weak var view: DetailPointViewProtocol?
}

// MARK: - DetailPointRouterProtocol
extension DetailPointRouter: DetailPointRouterProtocol {
    func openInMaps(latitude: Double, longitude: Double) {
        let url = URL(string: "https://maps.apple.com/?daddr=\(latitude),\(longitude)")
        guard let url else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func dismiss() {
        guard let uiView = view as? UIViewController else {
            return
        }
        
        uiView.dismiss(animated: true)
    }
}
