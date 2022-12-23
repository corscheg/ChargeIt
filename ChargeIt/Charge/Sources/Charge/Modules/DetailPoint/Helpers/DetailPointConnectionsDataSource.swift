//
//  DetailPointConnectionsDataSource.swift
//  
//
//  Created by Александр Казак-Казакевич on 19.12.2022.
//

import UIKit

/// A class that provides data to the Detail Point Connections collection view.
final class DetailPointConnectionsDataSource: NSObject {
    
    // MARK: Private Properties
    private var viewModels: [DetailPointViewModel.ConnectionViewModel] = []
    
    // MARK: Public Methods
    func updateDataSource(with viewModels: [DetailPointViewModel.ConnectionViewModel]) {
        self.viewModels = viewModels
    }
}

// MARK: - UICollectionViewDataSource
extension DetailPointConnectionsDataSource: UICollectionViewDataSource {    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "connection", for: indexPath) as? ConnectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.set(viewModel: viewModels[indexPath.item])
        return cell
    }
}
