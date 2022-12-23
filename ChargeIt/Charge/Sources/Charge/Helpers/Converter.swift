//
//  Converter.swift
//  
//
//  Created by Александр Казак-Казакевич on 21.12.2022.
//

import Foundation
import CoreData

/// A struct containing methods that convert different app objects into `DetailPointViewModel`s.
struct Converter {
    
    // MARK: Public Methods
    func makeViewModel(from model: ChargingPoint, didTapButton: @escaping (Bool) throws -> Void) -> DetailPointViewModel {
        let connections = Set(model.connections).map {
            let current: Current
            
            switch $0.currentType?.id {
            case 10, 20:
                current = .ac
            case 30:
                current = .dc
            default:
                current = .unknown
            }
            
            return DetailPointViewModel.ConnectionViewModel(
                type: $0.type.title,
                level: $0.level?.title,
                fastChargeCapable: $0.level?.fastChargeCapable,
                current: current
            )
        }
        
        var urls: [URL] = []
        
        if let medias = model.mediaItems {
            urls = medias.map {
                $0.url
            }
        }
        
        var approximateLocation = ""
        
        if let town = model.location.town {
            approximateLocation.append("\(town), ")
        }
        
        if let state = model.location.state {
            approximateLocation.append("\(state), ")
        }
        
        approximateLocation.append(model.location.country.code)
        
        let viewModel = DetailPointViewModel(
            uuid: model.uuid,
            id: model.id,
            approximateLocation: approximateLocation,
            addressFirst: model.location.addressFirst,
            addressSecond: model.location.addressSecond,
            locationTitle: model.location.title,
            connections: connections,
            imageURLs: urls,
            latitude: model.location.latitude,
            longitude: model.location.longitude,
            didTapFavoriteButton: didTapButton
        )
        
        return viewModel
    }
    
    func makeViewModel(from object: PointObj, didTapButton: @escaping (Bool) throws -> Void) -> DetailPointViewModel {
        var approximateLocation = ""
        if let town = object.town {
            approximateLocation.append("\(town), ")
        }
        if let state = object.state {
            approximateLocation.append("\(state), ")
        }
        approximateLocation.append(object.country)
        
        var connections: [DetailPointViewModel.ConnectionViewModel] = []
        object.connections.forEach { con in
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
        object.urls.forEach {
            guard let url = $0 as? URLsObj else {
                return
            }
            
            urls.append(url.url)
        }
        
        let viewModel = DetailPointViewModel(
            uuid: object.uuid,
            id: Int(object.serverID),
            approximateLocation: approximateLocation,
            addressFirst: object.addressFirst,
            addressSecond: object.addressSecond,
            locationTitle: object.locationTitle,
            connections: connections,
            imageURLs: urls,
            latitude: object.latitude,
            longitude: object.longitude,
            didTapFavoriteButton: didTapButton
        )
        
        return viewModel
    }
    
}
