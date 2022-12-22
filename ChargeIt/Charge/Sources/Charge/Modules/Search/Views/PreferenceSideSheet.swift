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
    
    private lazy var preferenceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.text = "Preferences"
        label.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    lazy var radiusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "Radius"
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        
        return label
    }()
    
    private lazy var radiusStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        
        return stack
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
    
    private lazy var radiusGroup = ControlGroupLayoutGuide(label: radiusLabel, control: radiusStack)
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "Country"
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        
        return label
    }()
    
    lazy var countryRestrictionControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Any", "Current"])
        
        return control
    }()
    
    private lazy var countryGroup = ControlGroupLayoutGuide(label: countryLabel, control: countryRestrictionControl)
    
    private lazy var usageTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "Usage Type"
        label.numberOfLines = 1
        label.textColor = .tertiaryLabel
        
        return label
    }()
    
    lazy var usageTypeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Public", "Any"])
        
        return control
    }()
    
    private lazy var usageTypeGroup = ControlGroupLayoutGuide(label: usageTypeLabel, control: usageTypeControl)
    
    lazy var offsetLayoutGuide = UILayoutGuide()
    private lazy var containerLayoutGuide = UILayoutGuide()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        addSubview(panSurface)
        layoutPanSurface()
        
        panSurface.addSubview(preferenceLabel)
        preferenceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addLayoutGuide(offsetLayoutGuide)
        layoutOffsetGuide()
        
        addLayoutGuide(containerLayoutGuide)
        containerLayoutGuide.snp.makeConstraints { make in
            make.top.bottom.equalTo(layoutMarginsGuide)
            make.left.equalTo(offsetLayoutGuide.snp.right).offset(15)
            make.right.equalTo(panSurface.snp.left).offset(-15)
        }
        
        addSubview(radiusLabel)
        addSubview(radiusStack)
        radiusStack.addArrangedSubview(radiusSlider)
        radiusStack.addArrangedSubview(radiusValueLabel)
        addLayoutGuide(radiusGroup)
        radiusGroup.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerLayoutGuide)
        }
        radiusGroup.layoutViews()
        radiusValueLabel.snp.makeConstraints { make in
            make.width.equalTo("500 km".width(withHeight: radiusValueLabel.frame.height, font: radiusValueLabel.font))
        }
        
        addSubview(countryLabel)
        addSubview(countryRestrictionControl)
        addLayoutGuide(countryGroup)
        countryGroup.snp.makeConstraints { make in
            make.top.equalTo(radiusGroup.snp.bottom).offset(15)
            make.left.right.equalTo(containerLayoutGuide)
        }
        countryGroup.layoutViews()
        countryRestrictionControl.selectedSegmentIndex = 0
        
        addSubview(usageTypeLabel)
        addSubview(usageTypeControl)
        addLayoutGuide(usageTypeGroup)
        usageTypeGroup.snp.makeConstraints { make in
            make.top.equalTo(countryGroup.snp.bottom).offset(15)
            make.left.right.bottom.equalTo(containerLayoutGuide)
        }
        usageTypeGroup.layoutViews()
        usageTypeControl.selectedSegmentIndex = 0
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
