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
    private let tableManager: FavoritesTableManager
    
    // MARK: Visual Components
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        return tableView
    }()
    
    // MARK: Initializers
    init(presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        self.tableManager = FavoritesTableManager(tableView: tableView)
        
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
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.delegate = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func set(points: [DetailPointViewModel]) {
        tableManager.setUpDataSource(with: points)
    }
    
    func showAlert(with message: String) {
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.itemTapped(at: indexPath.row)
    }
}

// MARK: - UINavigationControllerDelegate
extension FavoritesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController === self else {
            return
        }
        
        presenter.detailDismissed()
    }
}
