//
//  ConnectionView.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import UIKit

/// A view representing the single connection.
final class ConnectionViewCell: UICollectionViewCell {

    // MARK: Visual Components
    private lazy var type = ConnectionTitleView()
    
    private lazy var fastChargeCapableView = FastChargingView()
    
    private lazy var currentTypeView = CurrentTypeView()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGreen
        layer.cornerCurve = .continuous
        layer.cornerRadius = 15
        
        addSubview(type)
        type.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        addSubview(fastChargeCapableView)
        fastChargeCapableView.snp.makeConstraints { make in
            make.right.bottom.equalTo(layoutMarginsGuide)
            make.top.equalTo(type.snp.bottom).offset(8)
        }
        
        addSubview(currentTypeView)
        currentTypeView.snp.makeConstraints { make in
            make.left.bottom.equalTo(layoutMarginsGuide)
            make.top.equalTo(type.snp.bottom).offset(8)
            make.right.equalTo(fastChargeCapableView.snp.left).offset(-8)
            make.width.equalTo(fastChargeCapableView.snp.width).multipliedBy(0.9)
        }
        
        
    }
    
    convenience init(with viewModel: DetailPointViewModel.ConnectionViewModel) {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: DetailPointViewModel.ConnectionViewModel) {
        type.set(title: viewModel.type)
        fastChargeCapableView.set(available: viewModel.fastChargeCapable)
        currentTypeView.set(current: viewModel.current)
    }
    
}
