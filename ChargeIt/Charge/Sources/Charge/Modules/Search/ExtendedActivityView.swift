//
//  ExtendedActivityView.swift
//  
//
//  Created by Александр Казак-Казакевич on 04.12.2022.
//

import UIKit
import SnapKit

class ExtendedActivityView: UIView {
    
    let indicator = UIActivityIndicatorView()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        backgroundColor = .systemOrange
        
        snp.makeConstraints { make in
            make.width.equalTo(snp.height)
        }
        
        addSubview(indicator)
        indicator.startAnimating()
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
