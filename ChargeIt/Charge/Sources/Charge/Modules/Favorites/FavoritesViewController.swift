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
    
    // MARK: Visual Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        return tableView
    }()
    
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
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        presenter.viewDidLoad()
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    
}
