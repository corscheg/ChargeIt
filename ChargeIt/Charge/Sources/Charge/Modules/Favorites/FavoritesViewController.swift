//
//  FavoritesViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import UIKit

/// View of the Favorites module.
final class FavoritesViewController: UIViewController {

    // MARK: VIPER
    private let presenter: FavoritesPresenterProtocol
    
    // MARK: Public Properties
    let hapticsGenerator: HapticsGeneratorProtocol
    
    // MARK: Private Properties
    private let tableManager: FavoritesTableManager
    
    // MARK: Visual Components
    private var favoritesView = FavoritesView()
    var alert: AlertView?
    
    // MARK: Initializers
    init(presenter: FavoritesPresenterProtocol, hapticsGenerator: HapticsGeneratorProtocol) {
        self.presenter = presenter
        self.hapticsGenerator = hapticsGenerator
        self.tableManager = FavoritesTableManager(tableView: favoritesView.tableView)
        
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        favoritesView.tableView.delegate = self
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func set(points: [DetailPointViewModel]) {
        tableManager.setNewDataSource(with: points)
    }
    
    func remove(point: DetailPointViewModel) {
        tableManager.remove(viewModel: point)
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.itemTapped(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, handler in
            self?.presenter.requestDeletion(at: indexPath.row)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}

// MARK: - Alertable
extension FavoritesViewController: Alertable { }
