//
//  SettingsViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit

/// View of the Settings module.
final class SettingsViewController: UIViewController {

    // MARK: VIPER
    private let presenter: SettingsPresenterProtocol
    
    // MARK: Public Properties
    let hapticsGenerator: HapticsGeneratorProtocol
    
    // MARK: Private Properties
    private let defaultIdentifier = "deleteAll"
    private let maxCountIdentifier = "maxCountControl"
    private let tableViewDataSource: SettingsTableViewDataSource
    
    // MARK: Visual Components
    private let settingsView = SettingsView()
    var alert: AlertView?
    
    // MARK: Initializers
    init(presenter: SettingsPresenterProtocol, hapticsGenerator: HapticsGeneratorProtocol) {
        self.presenter = presenter
        self.hapticsGenerator = hapticsGenerator
        tableViewDataSource = SettingsTableViewDataSource(deleteIdentifier: defaultIdentifier, maxCountIdentifier: maxCountIdentifier)
        super.init(nibName: nil, bundle: nil)
        
        let imageName: String
        
        if #available(iOS 14, *) {
            imageName = "gearshape.fill"
        } else {
            imageName = "gear"
        }
                
        tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: imageName), tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        tableViewDataSource.maxCountControlDelegate = self
        settingsView.tableView.dataSource = tableViewDataSource
        settingsView.tableView.delegate = self
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultIdentifier)
        settingsView.tableView.register(MaxCountTableViewCell.self, forCellReuseIdentifier: maxCountIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
    
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {
    func updateUI(with viewModel: SettingsViewModel) {
        tableViewDataSource.set(viewModel: viewModel)
        settingsView.tableView.reloadData()
    }
    
    func presentDeletionConfirmationDialog() {
        let ac = UIAlertController(title: "Are you sure?", message: "You can not undo this action.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter.deletionConfirmed()
        })
        present(ac, animated: true)
    }
    
    func presentSignOutConfirmationDialog() {
        let ac = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.presenter.signOutConfirmed()
        })
        present(ac, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            presenter.clearFavoritesTapped()
        case (2, 0):
            presenter.authButtonTapped()
        default:
            break
        }
    }
}

// MARK: - Alertable
extension SettingsViewController: Alertable { }

// MARK: - MaxCountTableViewCellDelegate
extension SettingsViewController: MaxCountTableViewCellDelegate {
    func maxCountDidChange(to index: Int) {
        presenter.maxCountSettingIndexChanged(to: index)
    }
}
