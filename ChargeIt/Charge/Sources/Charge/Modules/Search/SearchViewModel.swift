//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 03.12.2022.
//

import Foundation
import MapKit

struct SearchViewModel {
    
    // MARK: Public Properties
    var locations: [CLLocationCoordinate2D] = []
    var region: MKCoordinateRegion = MKCoordinateRegion()
}
