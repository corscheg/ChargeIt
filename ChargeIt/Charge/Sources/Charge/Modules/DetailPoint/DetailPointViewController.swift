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
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
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
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }
    
    override func viewDidLoad() {
        presenter.askForUpdate()
    }
    
}

// MARK: - DetailPointViewProtocol
extension DetailPointViewController: DetailPointViewProtocol {
    func updateUI(with viewModel: DetailPointViewModel) {
        descriptionLabel.text = viewModel.description
    }
}
