//
//  DetailPointView.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit
import SnapKit

/// Visual components of the Detail Point module.
final class DetailPointView: UIView {

    // MARK: Visual Components
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        return scroll
    }()
    
    lazy var imagesScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isHidden = true
        
        return scroll
    }()
    
    lazy var imagesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 5
        
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var addressFirstlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var addressSecondLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var countryLabel: UILabel = {
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
    
    lazy var connectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: connetionViewLayout)
        collection.backgroundColor = .systemBackground
        collection.isScrollEnabled = false
        
        return collection
    }()
    
    lazy var favoriteStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        
        return stack
    }()
    
    lazy var favoriteView = FavoriteStarImage()
    
    lazy var favoriteButton: UIButton = {
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
    
    lazy var checkInButton: UIButton = {
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        
        return indicator
    }()
    
    lazy var openMapsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.setTitle("Open in Apple Maps", for: .normal)
        
        return button
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubviews()
        layout()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func updateUI(with viewModel: DetailPointViewModel) {
        titleLabel.text = viewModel.locationTitle ?? "Unknown"
        addressFirstlabel.text = viewModel.addressFirst
        addressSecondLabel.text = viewModel.addressSecond
        countryLabel.text = viewModel.approximateLocation
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
                        make.height.equalTo(self.snp.width).multipliedBy(screenRatio)
                    }
                    
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
                        self.layoutIfNeeded()
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
    
    func hideFavorite() {
        favoriteStack.isHidden = true
        favoriteStack.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    // MARK: Private Methods
    private func addSubviews() {
        addSubview(scrollView)
        
        scrollView.addSubview(imagesScroll)
        imagesScroll.addSubview(imagesStack)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(addressFirstlabel)
        scrollView.addSubview(addressSecondLabel)
        scrollView.addSubview(countryLabel)
        scrollView.addSubview(connectionView)
        scrollView.addSubview(favoriteStack)
        
        favoriteStack.addArrangedSubview(favoriteView)
        favoriteStack.addArrangedSubview(favoriteButton)
        
        scrollView.addSubview(mapsStack)
        
        mapsStack.addArrangedSubview(checkInButton)
        mapsStack.addArrangedSubview(openMapsButton)
        
        checkInButton.addSubview(activityIndicator)
    }
    
    private func layout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(layoutMarginsGuide).priority(800)
            make.width.equalTo(scrollView.contentLayoutGuide)
        }
        
        imagesScroll.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).priority(800)
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(imagesScroll.contentLayoutGuide)
        }
        
        imagesStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(imagesScroll.contentLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imagesScroll.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
        }
        
        addressFirstlabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        addressSecondLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(addressFirstlabel.snp.bottom).offset(10)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(addressSecondLabel.snp.bottom).offset(10)
        }
        
        connectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.height.equalTo(150)
        }
        
        favoriteStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(connectionView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        mapsStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scrollView.layoutMarginsGuide).priority(800)
            make.top.equalTo(favoriteStack.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
        }
        
        checkInButton.snp.makeConstraints { make in
            make.width.equalTo(openMapsButton.snp.height)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
