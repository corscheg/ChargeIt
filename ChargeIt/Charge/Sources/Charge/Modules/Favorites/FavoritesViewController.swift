//
//  FavoritesViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import UIKit

/// View of the Favorites module.
final class FavoritesViewController: UIViewController {

    // MARK: Private Properties
    private let presenter: FavoritesPresenterProtocol
    
    // MARK: Initializers
    init(presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    
}
