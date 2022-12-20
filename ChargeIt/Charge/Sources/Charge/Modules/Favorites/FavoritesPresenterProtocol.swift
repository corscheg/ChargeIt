//
//  FavoritesPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// A protocol of the Favorites module presenter.
protocol FavoritesPresenterProtocol: AnyObject {
    
    /// Notify presenter that view is able to present data.
    func viewDidLoad()
    
    /// Notify presenter that view will be visible.
    func viewDidAppear()
    
    /// Notify presenter that the item with the given index was tapped.
    func itemTapped(at index: Int)
}
