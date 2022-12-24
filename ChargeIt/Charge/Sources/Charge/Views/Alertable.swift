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
}

extension Alertable {
    func showSuccessAlert(with message: String?) {
        presentAlert(success: true, message: message)
    }
    
    func showErrorAlert(with message: String?) {
        presentAlert(success: false, message: message)
    }
    
    private func presentAlert(success: Bool, message: String?) {
        let feedback: UINotificationFeedbackGenerator.FeedbackType = success ? .success : .error
        
        hapticsGenerator.prepare()
        
        guard alert == nil else {
            hapticsGenerator.notificationOccurred(feedback)
            return
        }
        
        alert = AlertView(success: success, message: message)
        
        guard let alert else {
            return
        }
        
        alert.alpha = 0
        view.addSubview(alert)
        alert.layoutInSuperview()
        hapticsGenerator.notificationOccurred(feedback)
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0.9
        }
        
        hideAfterDelay()
    }
    
    private func hideAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.hideAlert()
        }
    }
    
    private func hideAlert() {
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
