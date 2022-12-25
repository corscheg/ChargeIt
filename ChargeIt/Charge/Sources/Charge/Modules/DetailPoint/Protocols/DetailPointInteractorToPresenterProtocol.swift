//
//  DetailPointInteractorToPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 22.12.2022.
//

import Foundation

/// A protocol of the Detail Point module presenter for the interactor.
protocol DetailPointInteractorToPresenterProtocol: AnyObject {
    
    /// Notify presenter that check-in was successful.
    func checkInSucceeded()
    
    /// Notify presenter that check-in failed.
    func checkInFailed(with error: LocalizedError)
}
