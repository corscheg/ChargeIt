//
//  Alertable.swift
//  
//
//  Created by Александр Казак-Казакевич on 24.12.2022.
//

import Foundation
import UIKit

/// A protocol that lets View Controllers present custom alerts.
protocol Alertable: UIViewController {
    
    var alert: AlertView? { get set }
    
    var hapticsGenerator: HapticsGeneratorProtocol { get }
    
    func showSuccessAlert(with message: String?)
    
    func showErrorAlert(with message: String?)
    
    func hideAlert()
}

extension Alertable {
    func showSuccessAlert(with message: String?) {
        hapticsGenerator.prepare()
        
        guard alert == nil else {
            hapticsGenerator.notificationOccurred(.success)
            return
        }
        
        alert = AlertView(success: true, message: message)
        
        guard let alert else {
            return
        }
        
        alert.alpha = 0
        view.addSubview(alert)
        alert.layoutInSuperview()
        hapticsGenerator.notificationOccurred(.success)
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0.9
        }
    }
    
    func showErrorAlert(with message: String?) {
        hapticsGenerator.prepare()
        
        guard alert == nil else {
            hapticsGenerator.notificationOccurred(.error)
            return
        }
        
        alert = AlertView(success: false, message: message)
        
        guard let alert else {
            return
        }
        
        alert.alpha = 0
        view.addSubview(alert)
        alert.layoutInSuperview()
        hapticsGenerator.notificationOccurred(.error)
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0.9
        }
    }
    
    func hideAlert() {
        guard let alert else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0
        } completion: { _ in
            alert.removeFromSuperview()
            self.alert = nil
        }
    }
}
