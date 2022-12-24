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
    let deleteIdentifier = "deleteAll"
    let maxCountIdentifier = "maxCountControl"
    
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
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: deleteIdentifier)
        settingsView.tableView.register(MaxCountTableViewCell.self, forCellReuseIdentifier: maxCountIdentifier)
        settingsView.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
    
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {
    func updateUI(with viewModel: SettingsViewModel) {
        guard let cell = settingsView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MaxCountTableViewCell else {
            return
        }
        
        cell.set(selectedIndex: viewModel.maxCountSelectedIndex)
    }
    
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
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: deleteIdentifier, for: indexPath)
            cell.textLabel?.text = "Clear Favorites"
            return cell
        case (1, 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: maxCountIdentifier, for: indexPath) as? MaxCountTableViewCell else {
                fallthrough
            }
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        
        let sectionDescription = "Large count of points may cause long-time loading or performance issues, especially on old devices or with poor internet connection. If this setting is less than count of points suitable to the given query options, the closest points will be presented."
        
        return sectionDescription
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.row, indexPath.section) {
        case (0, 0):
            presenter.clearFavoritesTapped()
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
