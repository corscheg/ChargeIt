//
//  FavoritesPresenter.swift
//  
//
//  Created by Александр Казак-Казакевич on 15.12.2022.
//

import Foundation

/// Presenter of the Favorites module.
final class FavoritesPresenter {
    
    // MARK: Private Properties
    private let interactor: FavoritesInteractor
    private let router: FavoritesRouter
    
    // MARK: Public Properties
    weak var view: FavoritesViewProtocol?
    
    // MARK: Initializers
    init(interactor: FavoritesInteractor, router: FavoritesRouter) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - FavoritesPresenterProtocol
extension FavoritesPresenter: FavoritesPresenterProtocol {
    func viewWillAppear() {
        do {
            let favoritesObj = try interactor.allFavorites()
            var favorites: [DetailPointViewModel] = []
            
            favoritesObj.forEach {
                var approximateLocation = ""
                if let town = $0.town {
                    approximateLocation.append("\(town), ")
                }
                if let state = $0.state {
                    approximateLocation.append("\(state), ")
                }
                approximateLocation.append($0.country ?? "Unknown")
                
                var connections: [DetailPointViewModel.ConnectionViewModel] = []
                $0.connections?.forEach { con in
                    guard let connection = con as? ConnectionObj else {
                        return
                    }
                    
                    connections.append(DetailPointViewModel.ConnectionViewModel(type: connection.type ?? "Unknown", level: connection.level, fastChargeCapable: connection.fastChargeCapable, current: connection.current))
                }
                
                var urls: [URL] = []
                $0.urls?.forEach {
                    guard let url = $0 as? URLsObj else {
                        return
                    }
                    
                    urls.append(url.url ?? URL(string: "https://apple.com")!)
                }
                
                favorites.append(DetailPointViewModel(
                    id: $0.uuid ?? UUID(),
                    approximateLocation: approximateLocation,
                    addressFirst: $0.addressFirst,
                    addressSecond: $0.addressSecond,
                    locationTitle: $0.locationTitle,
                    connections: connections,
                    imageURLs: urls,
                    latitude: $0.latitude,
                    longitude: $0.longitude,
                    isFavorite: true,
                    didTapFavoriteButton: { _ in })
                )
            }
            
            view?.set(points: favorites)
        } catch {
            view?.showAlert(with: error.localizedDescription)
        }
    }
}
