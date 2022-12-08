//
//  DetailPointViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import UIKit
import SnapKit

/// View of the Detail Point module.
class DetailPointViewController: UIViewController {

    // MARK: Private Properties
    private let presenter: DetailPointPresenterProtocol
    
    // MARK: Visual Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "Title"
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addressFirstlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Address line 1"
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addressSecondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Address line 2"
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = "Town, State, CN"
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: Initializers
    init(presenter: DetailPointPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        view.addSubview(addressFirstlabel)
        addressFirstlabel.snp.makeConstraints { make in
            make.leading.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(addressSecondLabel)
        addressSecondLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(addressFirstlabel.snp.bottom).offset(10)
        }
        
        view.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(addressSecondLabel.snp.bottom).offset(10)
        }
    }
    
    override func viewDidLoad() {
        presenter.askForUpdate()
    }
    
}

// MARK: - DetailPointViewProtocol
extension DetailPointViewController: DetailPointViewProtocol {
    func updateUI(with viewModel: DetailPointViewModel) {
        titleLabel.text = viewModel.locationTitle ?? "Unknown"
        addressFirstlabel.text = viewModel.addressFirst
        addressSecondLabel.text = viewModel.addressSecond
        
        var countryLine = ""
        if let town = viewModel.town {
            countryLine.append("\(town), ")
        }
        
        if let state = viewModel.state {
            countryLine.append("\(state), ")
        }
        countryLine.append(viewModel.country)
        
        countryLabel.text = countryLine
    }
}
