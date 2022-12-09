//
//  CurrentTypeView.swift
//  
//
//  Created by Александр Казак-Казакевич on 10.12.2022.
//

import UIKit
import SnapKit

/// A view representing a type of the current.
final class CurrentTypeView: UIView {

    // MARK: Visual Components
    private lazy var image: UIImageView = UIImageView()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        
        return label
    }()

    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 10
        
        image.tintColor = .black
        
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
    func set(current: String?) {
        label.text = current
        switch current {
        case "AC":
            image.image = UIImage(systemName: "line.3.horizontal")
        case "DC":
            image.image = UIImage(systemName: "water.waves")
            break
        default:
            label.text = "Unknown"
        }
    }

}
