//
//  PreferenceSideSheet.swift
//  
//
//  Created by Александр Казак-Казакевич on 04.12.2022.
//

import UIKit
import SnapKit

/// A view containing parameter controls of the search query.
final class PreferenceSideSheet: UIView {
    
    // MARK: Visual Components
    lazy var panSurface: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    lazy var radiusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "Radius"
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        
        return label
    }()
    
    lazy var radiusSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 20
        slider.minimumValue = 3
        
        
        return slider
    }()
    
    lazy var radiusValueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        
        return label
    }()
    
    lazy var offsetLayoutGuide: UILayoutGuide = UILayoutGuide()
    
    private lazy var radiusSliderLayoutGuide = SliderGroupLayoutGuide(label: radiusLabel, slider: radiusSlider, valueLabel: radiusValueLabel)

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        addSubview(panSurface)
        layoutPanSurface()
        
        addLayoutGuide(offsetLayoutGuide)
        layoutOffsetGuide()
        
        addSubview(radiusLabel)
        addSubview(radiusSlider)
        addSubview(radiusValueLabel)
        addLayoutGuide(radiusSliderLayoutGuide)
        radiusSliderLayoutGuide.snp.makeConstraints { make in
            make.top.bottom.equalTo(layoutMarginsGuide)
            make.left.equalTo(offsetLayoutGuide.snp.right).offset(15)
            make.right.equalTo(panSurface.snp.left).offset(-15)
        }
        radiusSliderLayoutGuide.layoutViews()
        radiusValueLabel.snp.makeConstraints { make in
            make.width.equalTo("500 km".width(withHeight: radiusValueLabel.frame.height, font: radiusValueLabel.font))
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func layoutPanSurface() {
        panSurface.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(10)
        }
    }
    
    func layoutOffsetGuide() {
        offsetLayoutGuide.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(10)
        }
    }
    
}
