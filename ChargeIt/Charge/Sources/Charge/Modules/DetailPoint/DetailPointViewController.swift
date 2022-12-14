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
    private let presenter: DetailPointPresenterProtocol
    
    // MARK: Visual Components
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
        label.text = "Title"
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addressFirstlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Address line 1"
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var addressSecondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        
        return button
    }()
    
    private lazy var openMapsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.setTitle("Open Apple Maps with directions", for: .normal)
        
        return button
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
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView.contentLayoutGuide)
        }
        
        scrollView.addSubview(imagesScroll)
        imagesScroll.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
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
        
        scrollView.addSubview(openMapsButton)
        openMapsButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(favoriteStack.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        connectionView.register(ConnectionViewCell.self, forCellWithReuseIdentifier: "connection")
        connectionView.dataSource = self
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        openMapsButton.addTarget(self, action: #selector(openMapsButtonTapped), for: .touchUpInside)
        
        presenter.viewDidLoad()
    }
    
    // MARK: Actions
    @objc private func favoriteButtonTapped() {
        presenter.favoriteButtonTapped()
    }
    
    @objc private func openMapsButtonTapped() {
        presenter.openMapsButtonTapped()
    }
    
}

// MARK: - DetailPointViewProtocol
extension DetailPointViewController: DetailPointViewProtocol {
    func updateUI(with viewModel: DetailPointViewModel) {
        titleLabel.text = viewModel.locationTitle ?? "Unknown"
        addressFirstlabel.text = viewModel.addressFirst
        addressSecondLabel.text = viewModel.addressSecond
        countryLabel.text = viewModel.approximateLocation
        connectionView.reloadData()
        
        viewModel.imageURLs.forEach {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: $0) { [weak self] result in
                guard let imageResult = try? result.get(), let self else {
                    return
                }
                
                if self.imagesScroll.isHidden {
                    self.imagesScroll.isHidden = false
                    
                    self.imagesStack.snp.makeConstraints { make in
                        make.height.equalTo(150)
                    }
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
                        self.view.layoutIfNeeded()
                    }
                }
                
                let ratio = imageResult.image.size.height / imageResult.image.size.width
                
                imageView.snp.makeConstraints { make in
                    make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
                }
                
                self.imagesStack.addArrangedSubview(imageView)
            }
        }
        
    }
    
    func setFavorite(state: Bool) {
        favoriteView.set(favorite: state)
        favoriteButton.setTitle(state ? "Remove from Favorites" : "Add to Favorites", for: .normal)
    }
    
    func showAlert(with message: String) {
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailPointViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfConnections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "connection", for: indexPath) as? ConnectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.set(viewModel: presenter.connection(at: indexPath.item))
        return cell
    }
}
