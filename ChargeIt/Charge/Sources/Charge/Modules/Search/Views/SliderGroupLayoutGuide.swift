//
//  SliderGroupLayoutGuide.swift
//  
//
//  Created by Александр Казак-Казакевич on 05.12.2022.
//

import UIKit

/// A `UILayoutGuide` that can layout a slider with title and value labels.
final class SliderGroupLayoutGuide: UILayoutGuide {
    
    // MARK: Private Properties
    private let label: UILabel
    private let slider: UISlider
    private let valueLabel: UILabel
    
    // MARK: Initializers
    init(label: UILabel, slider: UISlider, valueLabel: UILabel) {
        self.label = label
        self.slider = slider
        self.valueLabel = valueLabel
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
            make.top.leading.equalTo(self)
        }
        
        slider.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
        
        valueLabel.setContentCompressionResistancePriority(UILayoutPriority(770), for: .horizontal)
        valueLabel.setContentHuggingPriority(UILayoutPriority(770), for: .horizontal)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(slider.snp.trailing).offset(10)
            make.trailing.equalTo(self)
            make.centerY.equalTo(slider)
        }
        
    }
}
