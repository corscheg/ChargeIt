//
//  ControlGroupLayoutGuide.swift
//  
//
//  Created by Александр Казак-Казакевич on 05.12.2022.
//

import UIKit

/// A `UILayoutGuide` that can layout a control with title label.
final class ControlGroupLayoutGuide: UILayoutGuide {
    
    // MARK: Private Properties
    private let label: UILabel
    private let control: UIView
    
    // MARK: Initializers
    init(label: UILabel, control: UIView) {
        self.label = label
        self.control = control
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    /// Make constraints on the elements.
    /// **Call this method after both adding layout guide and subviews to the superview.**
    func layoutViews() {
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        
        control.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(self)
        }
        
    }
}
