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

    // MARK: Private Properties
    private let presenter: DetailPointViewToPresenterProtocol
    private let connectionViewDataSource: DetailPointConnectionsDataSource
    private let checkInButtonTransitionOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
    private let hapticsGenerator = UINotificationFeedbackGenerator()
    
    // MARK: Visual Components
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.systemOrange, for: .normal)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        return scroll
    }()
    
    private lazy var imagesScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isHidden = true
        
        return scroll
    }()
    
    private lazy var imagesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 5
        
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addressFirstlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addressSecondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
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
    
    private lazy var connetionViewLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        layout.configuration = config
        
        return layout
    }()
    
    private lazy var connectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: connetionViewLayout)
        collection.backgroundColor = .systemBackground
        collection.isScrollEnabled = false
        
        return collection
    }()
    
    private lazy var favoriteStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        
        return stack
    }()
    
    private lazy var favoriteView = FavoriteView()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemOrange
        
        return button
    }()
    
    private lazy var mapsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        
        return stack
    }()
    
    private lazy var checkInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = .systemRed
        let imageName: String
        if #available(iOS 15, *) {
            imageName = "smallcircle.filled.circle"
        } else {
            imageName = "smallcircle.fill.circle"
        }
        
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.imageView?.tintColor = .white
        
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        
        return indicator
    }()
    
    private lazy var openMapsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.setTitle("Open in Apple Maps", for: .normal)
        
        return button
    }()
    
    private var alert: AlertView?
    
    // MARK: Initializers
    init(presenter: DetailPointViewToPresenterProtocol, dataSource: DetailPointConnectionsDataSource) {
        self.presenter = presenter
        self.connectionViewDataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .popover
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        

        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.layoutMarginsGuide).priority(800)
            make.width.equalTo(scrollView.contentLayoutGuide)
        }
        
        scrollView.addSubview(imagesScroll)
        imagesScroll.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).priority(800)
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(imagesScroll.contentLayoutGuide)
        }

        imagesScroll.addSubview(imagesStack)
        imagesStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(imagesScroll.contentLayoutGuide)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imagesScroll.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
        }
        
        scrollView.addSubview(addressFirstlabel)
        addressFirstlabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        scrollView.addSubview(addressSecondLabel)
        addressSecondLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(addressFirstlabel.snp.bottom).offset(10)
        }
        
        scrollView.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(addressSecondLabel.snp.bottom).offset(10)
        }
        
        scrollView.addSubview(connectionView)
        connectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.height.equalTo(150)
        }
        
        scrollView.addSubview(favoriteStack)
        favoriteStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(connectionView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        favoriteStack.addArrangedSubview(favoriteView)
        favoriteStack.addArrangedSubview(favoriteButton)
        
        scrollView.addSubview(mapsStack)
        mapsStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(favoriteStack.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
        }
        
        mapsStack.addArrangedSubview(checkInButton)
        mapsStack.addArrangedSubview(openMapsButton)
        
        checkInButton.snp.makeConstraints { make in
            make.width.equalTo(openMapsButton.snp.height)
        }
        
        checkInButton.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        connectionView.register(ConnectionViewCell.self, forCellWithReuseIdentifier: "connection")
        connectionView.dataSource = connectionViewDataSource
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        openMapsButton.addTarget(self, action: #selector(openMapsButtonTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
        navigationItem.largeTitleDisplayMode = .never
        
        if navigationController != nil {
            dismissButton.isHidden = true
            dismissButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            
            favoriteStack.isHidden = true
            favoriteStack.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        presenter.viewDidLoad()
    }
    
    // MARK: Actions
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
        titleLabel.text = viewModel.locationTitle ?? "Unknown"
        addressFirstlabel.text = viewModel.addressFirst
        addressSecondLabel.text = viewModel.addressSecond
        countryLabel.text = viewModel.approximateLocation
        connectionViewDataSource.updateDataSource(with: viewModel.connections)
        connectionView.reloadData()
        
        imagesStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            imagesStack.removeArrangedSubview($0)
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
                
                if self.imagesScroll.isHidden {
                    self.imagesScroll.isHidden = false
                    
                    self.imagesStack.snp.makeConstraints { make in
                        make.height.equalTo(self.view.snp.width).multipliedBy(screenRatio)
                    }
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                self.imagesStack.addArrangedSubview(imageView)
            }
        }
        
    }
    
    func setFavorite(state: Bool) {
        favoriteView.set(favorite: state)
        favoriteButton.setTitle(state ? "Remove from Favorites" : "Add to Favorites", for: .normal)
    }
    
    func showErrorAlert(with message: String) {
        hapticsGenerator.prepare()
        guard alert == nil else {
            hapticsGenerator.notificationOccurred(.error)
            return
        }
        
        alert = AlertView(success: false, message: message)
        presentAlert()
        hapticsGenerator.notificationOccurred(.error)
    }
    
    func showSuccessAlert(with message: String) {
        hapticsGenerator.prepare()
        guard alert == nil else {
            hapticsGenerator.notificationOccurred(.success)
            return
        }
        
        alert = AlertView(success: true, message: message)
        presentAlert()
        hapticsGenerator.notificationOccurred(.success)
    }
    
    private func presentAlert() {
        guard let alert else {
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
        guard let alert else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            alert.alpha = 0
        } completion: { _ in
            alert.removeFromSuperview()
            self.alert = nil
        }
    }
    
    func startActivityIndication() {
        checkInButton.isEnabled = false
        
        guard let image = checkInButton.imageView else {
            activityIndicator.startAnimating()
            return
        }
        
        UIView.transition(with: image, duration: 0.3, options: checkInButtonTransitionOptions) { }
        
        UIView.transition(with: activityIndicator, duration: 0.3, options: checkInButtonTransitionOptions) {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndication() {
        checkInButton.isEnabled = true
        
        guard let image = checkInButton.imageView else {
            activityIndicator.stopAnimating()
            return
        }
        
        UIView.transition(with: image, duration: 0.3, options: checkInButtonTransitionOptions) { }
        
        UIView.transition(with: activityIndicator, duration: 0.3, options: checkInButtonTransitionOptions) {
            self.activityIndicator.stopAnimating()
        }
    }
}
