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
    private let hapticsGenerator: HapticsGeneratorProtocol
    
    // MARK: Visual Components
    private lazy var detailPointView = DetailPointView()
    
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
        detailPointView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        detailPointView.checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
        navigationItem.largeTitleDisplayMode = .never
        
        if navigationController != nil {
            detailPointView.dismissButton.isHidden = true
            detailPointView.dismissButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            detailPointView.favoriteStack.isHidden = true
            detailPointView.favoriteStack.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
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
        detailPointView.titleLabel.text = viewModel.locationTitle ?? "Unknown"
        detailPointView.addressFirstlabel.text = viewModel.addressFirst
        detailPointView.addressSecondLabel.text = viewModel.addressSecond
        detailPointView.countryLabel.text = viewModel.approximateLocation
        connectionViewDataSource.updateDataSource(with: viewModel.connections)
        detailPointView.connectionView.reloadData()
        
        detailPointView.imagesStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            detailPointView.imagesStack.removeArrangedSubview($0)
        }
        
        viewModel.imageURLs.forEach {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: $0) { [weak self] result in
                guard let imageResult = try? result.get(), let self else {
                    return
                }
                
                let ratio = imageResult.image.size.height / imageResult.image.size.width
                
                imageView.snp.makeConstraints { make in
                    make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
                }
                
                let screenRatio = ratio > 1 ? 1 : ratio
                
                if self.detailPointView.imagesScroll.isHidden {
                    self.detailPointView.imagesScroll.isHidden = false
                    
                    self.detailPointView.imagesStack.snp.makeConstraints { make in
                        make.height.equalTo(self.view.snp.width).multipliedBy(screenRatio)
                    }
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                self.detailPointView.imagesStack.addArrangedSubview(imageView)
            }
        }
        
    }
    
    func setFavorite(state: Bool) {
        detailPointView.favoriteView.set(favorite: state)
        detailPointView.favoriteButton.setTitle(state ? "Remove from Favorites" : "Add to Favorites", for: .normal)
    }
    
    func showErrorAlert(with message: String) {
        hapticsGenerator.prepare()
        guard detailPointView.alert == nil else {
            hapticsGenerator.notificationOccurred(.error)
            return
        }
        
        detailPointView.alert = AlertView(success: false, message: message)
        presentAlert()
        hapticsGenerator.notificationOccurred(.error)
    }
    
    func showSuccessAlert(with message: String) {
        hapticsGenerator.prepare()
        guard detailPointView.alert == nil else {
            hapticsGenerator.notificationOccurred(.success)
            return
        }
        
        detailPointView.alert = AlertView(success: true, message: message)
        presentAlert()
        hapticsGenerator.notificationOccurred(.success)
    }
    
    private func presentAlert() {
        guard let alert = detailPointView.alert else {
            return
        }
        
        alert.alpha = 0
        view.addSubview(alert)
        alert.layoutInSuperview()
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0.9
        }
    }
    
    func hideAlert() {
        guard let alert = detailPointView.alert else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0
        } completion: { _ in
            alert.removeFromSuperview()
            self.detailPointView.alert = nil
        }
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
