//
//  DetailPointViewModel.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A struct that maps to Detail Point view and is used in Detail Point module.
struct DetailPointViewModel {
    
    // MARK: Public Properties
    let country: String
    let state: String?
    let town: String?
    let addressFirst: String?
    let addressSecond: String?
    let locationTitle: String?
    let connections: [ConnectionViewModel]
    let imageURLs: [URL]
}

// MARK: - ConnectionViewModel {
extension DetailPointViewModel {
    struct ConnectionViewModel {
        
        // MARK: Public Properties
        let type: String
        let level: String?
        let fastChargeCapable: Bool?
        let current: String?
    }
}
