//
//  SearchView.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit
import MapKit
import SnapKit

/// Visual components of the Favorites module.
final class SearchView: UIView {

    // MARK: Visual Components
    lazy var map: MKMapView = MKMapView()
    
    lazy var nearbyButton: UIButton = {
        let button: UIButton
        button = UIButton(type: .custom)
        button.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        
        button.setTitle("Find Nearby", for: .normal)
        button.setTitle("Enable Location Services", for: .disabled)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var nearbyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        return stack
    }()
    
    lazy var activityIndicator: ExtendedActivityView = {
        let indicator = ExtendedActivityView()
        indicator.isHidden = true
        indicator.alpha = 0
        indicator.transform = CGAffineTransform(scaleX: 1, y: 0.5)
        
        return indicator
    }()
    
    lazy var sideSheet: PreferenceSideSheet = {
        let sheet = PreferenceSideSheet()
        
        return sheet
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        layout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func addSubviews() {
        addSubview(map)
        map.addSubview(nearbyStack)
        nearbyStack.addArrangedSubview(activityIndicator)
        activityIndicator.transform = activityIndicator.transform.concatenating(CGAffineTransform(translationX: activityIndicator.frame.width, y: 0))
        nearbyStack.addArrangedSubview(nearbyButton)
        addSubview(sideSheet)
    }
    
    private func layout() {
        map.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
        
        nearbyStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        nearbyButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        nearbyButton.titleLabel?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }
        
        sideSheet.snp.makeConstraints { make in
            make.bottom.equalTo(nearbyStack.snp.top).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
        
        sideSheet.panSurface.snp.makeConstraints { make in
            make.left.equalTo(snp.left)
        }
    }
    
}
