//
//  ShimmerLabel.swift
//  
//
//  Created by Александр Казак-Казакевич on 25.12.2022.
//

import UIKit
import SnapKit

/// A label with shimmer effect.
final class ShimmerLabel: UIView {

    // MARK: Visual Components
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.colors = [
            UIColor.black.cgColor,
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        
        layer.locations = [0.25, 0.5, 0.75]
        
        return layer
    }()
    
    // MARK: Private Properties
    private let font: UIFont = .preferredFont(forTextStyle: .caption1)
    private let text: String
    private let attributes: [NSAttributedString.Key: AnyObject]
    private let animation: CABasicAnimation
    
    // MARK: Initializers
    init(frame: CGRect, text: String) {
        self.text = text
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attributes = [.font: font, .paragraphStyle: style]
        
        animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 4
        animation.repeatCount = .infinity
        
        super.init(frame: frame)
        
        layer.addSublayer(gradientLayer)
        clipsToBounds = true
        
        
        gradientLayer.add(animation, forKey: nil)
        
        snp.makeConstraints { make in
            make.width.equalTo(text.bounding(font: font).width)
            make.height.equalTo(text.bounding(font: font).height)
        }
    }
    
    convenience init(text: String) {
        self.init(frame: .zero, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: -bounds.width, y: bounds.origin.y, width: 3 * bounds.width, height: bounds.height)
        
//        setNeedsDisplay()
        let image = UIGraphicsImageRenderer(size: bounds.size).image { _ in
            text.draw(in: bounds, withAttributes: attributes)
        }
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame = bounds.offsetBy(dx: bounds.width, dy: 0)
        maskLayer.contents = image.cgImage
        gradientLayer.mask = maskLayer
        
    }
    
    // MARK: Public Methods
    func stopAnimation() {
        gradientLayer.removeAllAnimations()
    }
    
    func resumeAnimation() {
        gradientLayer.add(animation, forKey: nil)
    }
    
}
