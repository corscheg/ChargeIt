//
//  SettingsView.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit

/// Visual components of the Settings module.
final class SettingsView: UIView {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
