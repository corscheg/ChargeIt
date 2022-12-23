//
//  HapticsGeneratorProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import Foundation
import UIKit

protocol HapticsGeneratorProtocol {
    func prepare()
    
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType)
}

extension UINotificationFeedbackGenerator: HapticsGeneratorProtocol { }
