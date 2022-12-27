//
//  SearchViewToPresenterProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import MapKit

/// A protocol of the Search module presenter for the view.
protocol SearchViewToPresenterProtocol: AnyObject {
    
    /// Update the view with the current View Model.
    func viewDidLoad()
    
    /// Update the view with the new value of radius.
    func radiusChanged(value: Float)
    
    /// Say presenter that country restriction has a new status.
    func countryRestrictionIndexChanged(to newValue: Int)
    
    /// Say presenter thet usage type has a new status.
    func usageTypeIndexChanged(to newValue: Int)
    
    /// Update the View Model with the new value of Map Region.
    func mapRegionChanged(to: MKCoordinateRegion)
    
    /// Ask to load the closest charging points with current parameters.
    func loadNearbyPoints()
    
    /// Call this method once the user tapped on the item.
    func itemTapped(at index: Int)
}
