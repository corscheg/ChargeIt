//
//  AuthView.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import UIKit

/// Visual components of the Auth module.
class AuthView: UIView {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
