//
//  DetailPointViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import UIKit
import SnapKit
import Kingfisher

/// View of the Detail Point module.
final class DetailPointViewController: UIViewController {

    // MARK: VIPER
    private let presenter: DetailPointViewToPresenterProtocol
    
    // MARK: Private Properties
    private let connectionViewDataSource = DetailPointConnectionsDataSource()
    private let checkInButtonTransitionOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
    
    // MARK: Public Properties
    let hapticsGenerator: HapticsGeneratorProtocol
    
    // MARK: Visual Components
    private lazy var detailPointView = DetailPointView()
    var alert: AlertView?
    
    // MARK: Initializers
    init(presenter: DetailPointViewToPresenterProtocol, hapticsGenerator: HapticsGeneratorProtocol) {
        self.presenter = presenter
        self.hapticsGenerator = hapticsGenerator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = detailPointView
    }
    
    override func viewDidLoad() {
        detailPointView.connectionView.register(ConnectionViewCell.self, forCellWithReuseIdentifier: "connection")
        detailPointView.connectionView.dataSource = connectionViewDataSource
        
        detailPointView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        detailPointView.openMapsButton.addTarget(self, action: #selector(openMapsButtonTapped), for: .touchUpInside)
        detailPointView.checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let navigationController {
            if navigationController.viewControllers.first === self {
                let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissButtonTapped))
                navigationItem.rightBarButtonItem = dismissButton
            } else {
                detailPointView.hideFavorite()
            }
        }
        
        title = "Charging Point"
        
        presenter.viewDidLoad()
    }
}

// MARK: - Actions
extension DetailPointViewController {
    @objc private func favoriteButtonTapped() {
        presenter.favoriteButtonTapped()
    }
    
    @objc private func openMapsButtonTapped() {
        presenter.openMapsButtonTapped()
    }
    
    @objc private func dismissButtonTapped() {
        presenter.dismissButtonTapped()
    }
    
    @objc private func checkInButtonTapped() {
        presenter.checkInTapped()
    }
}

// MARK: - DetailPointViewProtocol
extension DetailPointViewController: DetailPointViewProtocol {
    func updateUI(with viewModel: DetailPointViewModel) {
        connectionViewDataSource.updateDataSource(with: viewModel.connections)
        detailPointView.updateUI(with: viewModel)
    }
    
    func setFavorite(state: Bool) {
        detailPointView.setFavorite(state: state)
    }
    
    func startActivityIndication() {
        detailPointView.checkInButton.isEnabled = false
        
        guard let image = detailPointView.checkInButton.imageView else {
            detailPointView.activityIndicator.startAnimating()
            return
        }
        
        UIView.transition(with: image, duration: 0.3, options: checkInButtonTransitionOptions) { }
        
        UIView.transition(with: detailPointView.activityIndicator, duration: 0.3, options: checkInButtonTransitionOptions) {
            self.detailPointView.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndication() {
        detailPointView.checkInButton.isEnabled = true
        
        guard let image = detailPointView.checkInButton.imageView else {
            detailPointView.activityIndicator.stopAnimating()
            return
        }
        
        UIView.transition(with: image, duration: 0.3, options: checkInButtonTransitionOptions) { }
        
        UIView.transition(with: detailPointView.activityIndicator, duration: 0.3, options: checkInButtonTransitionOptions) {
            self.detailPointView.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Alertable
extension DetailPointViewController: Alertable { }
