//
//  AlertView.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit
import SnapKit

/// A pretty alert without actions.
final class AlertView: UIView {

    // MARK: Visual Components
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: Initializers
    init(frame: CGRect, success: Bool, message: String? = nil) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        backgroundColor = .black
        alpha = 0.8
        
        if success {
            image.tintColor = .systemGreen
            messageLabel.textColor = .systemGreen
            image.image = UIImage(systemName: "checkmark.circle")
        } else {
            image.tintColor = .systemRed
            messageLabel.textColor = .systemRed
            image.image = UIImage(systemName: "xmark.circle")
        }
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalTo(layoutMarginsGuide).inset(15)
        }
        
        stack.addArrangedSubview(image)
        image.snp.makeConstraints { make in
            make.height.equalTo(image.snp.width)
        }
        
        if let message {
            messageLabel.text = message
            stack.addArrangedSubview(messageLabel)
        }
    }
    
    convenience init(success: Bool, message: String? = nil) {
        self.init(frame: .zero, success: success, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func layoutInSuperview() {
        snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
        }
    }
    
}
