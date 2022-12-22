//
//  ControlLabel.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit

/// A `UILabel` used for marking controls' purposes.
final class ControlLabel: UILabel {

    // MARK: Initializers
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.text = text
        font = .preferredFont(forTextStyle: .caption1)
        numberOfLines = 1
        textColor = .tertiaryLabel
    }
    
    convenience init(text: String) {
        self.init(frame: .zero, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
