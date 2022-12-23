//
//  SettingsPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation

/// A protocol of the Settings module presenter.
protocol SettingsPresenterProtocol: AnyObject {
    
    /// Notify presenter that the user wants to remove all favorite points.
    func requestAllDelete()
    
    /// Notify presenter that the deletion was confirmed.
    func deletionConfirmed()
}
