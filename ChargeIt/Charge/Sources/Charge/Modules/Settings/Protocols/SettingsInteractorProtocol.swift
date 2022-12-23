//
//  SettingsInteractorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// A protocol of the Settings module interactor.
protocol SettingsInteractorProtocol {
    
    /// Request deletion of all favorite points.
    func deleteAll() throws
}
