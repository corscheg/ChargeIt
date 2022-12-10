//
//  DetailPointInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import Foundation

/// A protocol of the Detail Point module interactor.
protocol DetailPointInteractorProtocol {
    
    /// Fetch images and callback the presenter on each loaded photo.
    func fetchPhotos(with urls: [URL])
}
