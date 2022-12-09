//
//  ConnectionTitleView.swift
//  
//
//  Created by Александр Казак-Казакевич on 10.12.2022.
//

import UIKit
import SnapKit

/// A view for displaying a connection title.
final class ConnectionTitleView: UIView {
    
    // MARK: Visual Components
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGreen
        
        return label
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5).priority(800)
            make.leading.greaterThanOrEqualTo(layoutMarginsGuide)
            make.trailing.lessThanOrEqualTo(layoutMarginsGuide)
            make.centerX.equalToSuperview()
        }
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 10
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func set(title: String) {
        label.text = title
    }
    
}
