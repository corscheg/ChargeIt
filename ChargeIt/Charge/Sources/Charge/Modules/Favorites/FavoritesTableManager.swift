//
//  FavoritesTableManager.swift
//  
//
//  Created by Александр Казак-Казакевич on 18.12.2022.
//

import Foundation
import UIKit

/// A class that handles UITableView in Favorites view.
final class FavoritesTableManager {
    
    // MARK: Private Properties
    private let dataSource: UITableViewDiffableDataSource<FavoritesSection, DetailPointViewModel>
    private var snapshot = NSDiffableDataSourceSnapshot<FavoritesSection, DetailPointViewModel>()
    
    // MARK: Initializers
    init(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = itemIdentifier.locationTitle
            cell.detailTextLabel?.text = itemIdentifier.approximateLocation
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        snapshot.appendSections([.main])
    }
    
    // MARK: Public Properties
    func setNewDataSource(with viewModels: [DetailPointViewModel]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    func remove(viewModel: DetailPointViewModel) {
        snapshot.deleteItems([viewModel])
        dataSource.apply(snapshot)
    }
}
