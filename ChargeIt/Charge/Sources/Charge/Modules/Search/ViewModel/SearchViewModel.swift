//
//  SearchViewModel.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import MapKit

/// A struct that maps to Search View and is used in Search module.
struct SearchViewModel {
    
    // MARK: Public Properties
    var locations: [CLLocationCoordinate2D] = []
    var region: MKCoordinateRegion = MKCoordinateRegion()
}
