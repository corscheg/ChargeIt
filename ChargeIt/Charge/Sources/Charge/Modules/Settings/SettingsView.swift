//
//  SettingsView.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit

/// Visual components of the Settings module.
final class SettingsView: UIView {
    
    // MARK: Visual Components
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        return table
    }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addAndLayoutSubviews()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func addAndLayoutSubviews() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
