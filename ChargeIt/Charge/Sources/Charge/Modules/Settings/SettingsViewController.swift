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
    
    // MARK: Visual Components
    private let settingsView = SettingsView()
    var alert: AlertView?
    
    // MARK: Initializers
    init(presenter: SettingsPresenterProtocol, hapticsGenerator: HapticsGeneratorProtocol) {
        self.presenter = presenter
        self.hapticsGenerator = hapticsGenerator
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
        
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "deleteAll")
    }
    
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {
    func presentConfirmationDialog() {
        let ac = UIAlertController(title: "Are you sure?", message: "You can not undo this action.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter.deletionConfirmed()
        })
        present(ac, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteAll", for: indexPath)
            cell.textLabel?.text = "Clear Favorites"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.row, indexPath.section) {
        case (0, 0):
            presenter.requestAllDelete()
        default:
            break
        }
    }
}

// MARK: - Alertable
extension SettingsViewController: Alertable { }
