//
//  PreferenceSideSheet.swift
//  
//
//  Created by Александр Казак-Казакевич on 04.12.2022.
//

import UIKit
import SnapKit

class PreferenceSideSheet: UIView {
    
    lazy var panSurface: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.isUserInteractionEnabled = true
        
        return view
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        addSubview(panSurface)
        panSurface.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(10)
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
