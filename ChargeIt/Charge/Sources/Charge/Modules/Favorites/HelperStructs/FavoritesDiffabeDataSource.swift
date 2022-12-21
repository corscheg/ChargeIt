//
//  FavoritesDiffabeDataSource.swift
//  
//
//  Created by Александр Казак-Казакевич on 21.12.2022.
//

import UIKit

/// A subclass of `UITableViewDiffableDataSource` necessary for overriding of `UITableViewDataSource` methods.
class FavoritesDiffabeDataSource: UITableViewDiffableDataSource<FavoritesSection, DetailPointViewModel> {
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
