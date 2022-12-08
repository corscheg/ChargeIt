//
//  IdentifiablePlacemark.swift
//  
//
//  Created by Александр Казак-Казакевич on 08.12.2022.
//

import MapKit

/// A placemark which contains an index.
class IdentifiablePlacemark: MKPlacemark {
    
    // MARK: Public Properties
    let id: Int
    
    // MARK: Initializers
    init(coordinate: CLLocationCoordinate2D, id: Int) {
        self.id = id
        super.init(coordinate: coordinate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
