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
    private var viewModels: [DetailPointViewModel] = []
    private var detailChangedState = false
    private var selectedIndex: Int?
    
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
    func viewDidAppear() {
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
                approximateLocation.append($0.country)
                
                var connections: [DetailPointViewModel.ConnectionViewModel] = []
                $0.connections.forEach { con in
                    guard let connection = con as? ConnectionObj else {
                        return
                    }
                    
                    let current: Current
                    
                    switch connection.current {
                    case "AC":
                        current = .ac
                    case "DC":
                        current = .dc
                    default:
                        current = .unknown
                    }
                    
                    connections.append(DetailPointViewModel.ConnectionViewModel(type: connection.type, level: connection.level, fastChargeCapable: connection.fastChargeCapable, current: current))
                }
                
                var urls: [URL] = []
                $0.urls.forEach {
                    guard let url = $0 as? URLsObj else {
                        return
                    }
                    
                    urls.append(url.url)
                }
                
                favorites.append(DetailPointViewModel(
                    id: $0.uuid,
                    approximateLocation: approximateLocation,
                    addressFirst: $0.addressFirst,
                    addressSecond: $0.addressSecond,
                    locationTitle: $0.locationTitle,
                    connections: connections,
                    imageURLs: urls,
                    latitude: $0.latitude,
                    longitude: $0.longitude,
                    isFavorite: true
                ) { [weak self] _ in
                    self?.detailChangedState.toggle()
                })
            }
            
            viewModels = favorites
            view?.set(points: favorites)
        } catch {
            view?.showAlert(with: error.localizedDescription)
        }
    }
    
    func itemTapped(at index: Int) {
        selectedIndex = index
        router.revealDetail(with: viewModels[index])
    }
    
    func detailDismissed() {
        defer {
            selectedIndex = nil
            detailChangedState = false
        }
        
        guard let selectedIndex, detailChangedState else {
            return
        }
        
        do {
            let id = viewModels[selectedIndex].id
            try interactor.deletePoint(by: id)
        } catch {
            view?.showAlert(with: "Unable to remove the point")
        }        
    }
}
