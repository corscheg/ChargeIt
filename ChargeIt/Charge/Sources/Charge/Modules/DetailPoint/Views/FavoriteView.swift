//
//  FavoriteView.swift
//  
//
//  Created by Александр Казак-Казакевич on 12.12.2022.
//

import UIKit
import SnapKit

/// A view for representing favorite state.
final class FavoriteView: UIView {
    
    // MARK: Private Properties
    private let favorite = UIImage(systemName: "star.fill")
    private let notFavorite = UIImage(systemName: "star")
    
    // MARK: Visual Components
    private lazy var starView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(starView)
        starView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(snp.width)
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func set(favorite: Bool) {
        starView.image = favorite ? self.favorite : notFavorite
    }
    
}
