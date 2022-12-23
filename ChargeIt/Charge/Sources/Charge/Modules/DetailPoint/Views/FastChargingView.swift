//
//  FastChargingView.swift
//  
//
//  Created by Александр Казак-Казакевич on 10.12.2022.
//

import UIKit
import SnapKit

/// A view indicating availability of fast charge.
final class FastChargingView: UIView {
    
    // MARK: Visual Components
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        
        return label
    }()

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 10
        
        addSubview(image)
        image.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide)
            make.left.greaterThanOrEqualTo(layoutMarginsGuide)
            make.right.lessThanOrEqualTo(layoutMarginsGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(image.snp.width)
        }
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(layoutMarginsGuide)
            make.top.equalTo(image.snp.bottom).offset(5)
        }
        
    }
    
    convenience init () {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func set(available: Bool?) {
        guard let available else {
            image.image = UIImage(systemName: "questionmark")
            image.tintColor = .systemYellow
            
            label.text = "Unknown"
            label.textColor = .systemYellow
            
            return
        }
        
        if available {
            image.image = UIImage(systemName: "checkmark.circle")
            image.tintColor = .systemGreen
            
            label.text = "Fast\nCharge"
            label.textColor = .systemGreen
        } else {
            image.image = UIImage(systemName: "xmark.circle")
            image.tintColor = .systemRed
            
            label.text = "No Fast\nCharge"
            label.textColor = .systemRed
        }
    }
    
}
