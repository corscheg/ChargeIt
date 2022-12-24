//
//  MaxCountTableViewCell.swift
//  
//
//  Created by Александр Казак-Казакевич on 24.12.2022.
//

import UIKit
import SnapKit

/// A `UITableViewCell` that presents the maximum point count setting.
final class MaxCountTableViewCell: UITableViewCell {
    
    // MARK: Public Properties
    weak var delegate: MaxCountTableViewCellDelegate?

    // MARK: Visual Components
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.text = "Maximum points returned from Search"
        
        return label
    }()
    
    private lazy var control: UISegmentedControl = {
        let control = UISegmentedControl(items: ["100", "1000", "5000", "10000"])
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addAndLayoutSubviews()
        control.addTarget(self, action: #selector(controlDidChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func set(selectedIndex: Int) {
        control.selectedSegmentIndex = selectedIndex
    }
    
    // MARK: Private Methods
    private func addAndLayoutSubviews() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView.layoutMarginsGuide)
        }
        
        contentView.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }
    
    // MARK: Actions
    @objc private func controlDidChange() {
        delegate?.maxCountDidChange(to: control.selectedSegmentIndex)
    }
    
}
