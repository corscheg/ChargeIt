//
//  SettingsTableViewDataSource.swift
//  
//
//  Created by Александр Казак-Казакевич on 25.12.2022.
//

import Foundation
import UIKit

final class SettingsTableViewDataSource: NSObject {
    
    // MARK: Private Properties
    private var viewModel: SettingsViewModel?
    private let deleteIdentifier: String
    private let maxCountIdentifier: String
    
    // MARK: Public Properties
    weak var maxCountControlDelegate: MaxCountTableViewCellDelegate?
    
    // MARK: Initializers
    init(deleteIdentifier: String, maxCountIdentifier: String) {
        self.deleteIdentifier = deleteIdentifier
        self.maxCountIdentifier = maxCountIdentifier
        super.init()
    }
    
    // MARK: Public Methods
    func set(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource
extension SettingsTableViewDataSource: UITableViewDataSource {
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
            cell.set(selectedIndex: viewModel?.maxCountSelectedIndex ?? 0)
            cell.delegate = maxCountControlDelegate
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
