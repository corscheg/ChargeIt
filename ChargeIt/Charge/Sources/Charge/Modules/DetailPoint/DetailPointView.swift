//
//  DetailPointView.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit
import SnapKit

/// Visual components of the Detail View module.
final class DetailPointView: UIView {

    // MARK: Visual Components
    lazy var dismissButton: UIButton = {
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
        addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(layoutMarginsGuide).priority(800)
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
}
