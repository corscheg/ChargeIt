//
//  ConnectionView.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import UIKit

/// A view representing the single connection.
class ConnectionView: UIView {

    // MARK: Visual Components
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private lazy var fastChargeCapableLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private lazy var currentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    // MARK: Initializers
    init(with viewModel: DetailPointViewModel.ConnectionViewModel, frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(layoutMarginsGuide)
        }
        
        addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.top.equalTo(typeLabel.snp.bottom).offset(5)
        }
        
        addSubview(fastChargeCapableLabel)
        fastChargeCapableLabel.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.top.equalTo(levelLabel.snp.bottom).offset(5)
        }
        
        addSubview(currentLabel)
        currentLabel.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.top.equalTo(fastChargeCapableLabel.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(layoutMarginsGuide)
        }
        
        typeLabel.text = viewModel.type
        levelLabel.text = viewModel.level
        if let fastChargeCapable = viewModel.fastChargeCapable {
            fastChargeCapableLabel.text = fastChargeCapable ? "Fast Charge" : "No Fast Charge"
        }
        currentLabel.text = viewModel.current
    }
    
    convenience init(with viewModel: DetailPointViewModel.ConnectionViewModel) {
        self.init(with: viewModel, frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
