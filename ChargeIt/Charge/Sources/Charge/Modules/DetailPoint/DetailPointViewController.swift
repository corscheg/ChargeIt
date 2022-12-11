//
//  DetailPointViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import UIKit
import SnapKit

/// View of the Detail Point module.
final class DetailPointViewController: UIViewController {

    // MARK: Private Properties
    private let presenter: DetailPointPresenterProtocol
    
    // MARK: Visual Components
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
        
        view.addSubview(imagesScroll)
        imagesScroll.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imagesScroll.contentLayoutGuide)
            make.height.equalTo(150)
        }
        
        imagesScroll.addSubview(imagesStack)
        imagesStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(imagesScroll.contentLayoutGuide)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        view.addSubview(addressFirstlabel)
        addressFirstlabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(addressSecondLabel)
        addressSecondLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(addressFirstlabel.snp.bottom).offset(10)
        }
        
        view.addSubview(countryLabel)
        countryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(addressSecondLabel.snp.bottom).offset(10)
        }
        
        view.addSubview(connectionView)
        connectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.height.equalTo(150)
        }
        
        view.addSubview(favoriteStack)
        favoriteStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.top.equalTo(connectionView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        favoriteStack.addArrangedSubview(favoriteView)
        favoriteStack.addArrangedSubview(favoriteButton)
    }
    
    override func viewDidLoad() {
        connectionView.register(ConnectionViewCell.self, forCellWithReuseIdentifier: "connection")
        connectionView.dataSource = self
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        presenter.viewDidLoad()
    }
    
    // MARK: Actions
    @objc private func favoriteButtonTapped() {
        presenter.favoriteButtonTapped()
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
        
    }
    
    func addImage(with data: Data) {
        guard let image = UIImage(data: data) else {
            return
        }
        
        sleep(1)
        
        if imagesScroll.isHidden {
            imagesScroll.isHidden = false
            
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(imagesScroll.snp.bottom).offset(15)
                make.leading.trailing.equalTo(view.layoutMarginsGuide)
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            }
        }
        
        let imageView = UIImageView(image: image)
        let ratio = imageView.frame.height / imageView.frame.width
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        imagesStack.addArrangedSubview(imageView)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut]) {
            imageView.isHidden = false
        }
    }
    
    func setFavorite(state: Bool) {
        favoriteView.set(favorite: state)
        favoriteButton.setTitle(state ? "Remove from Favorites" : "Add to Favorites", for: .normal)
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
