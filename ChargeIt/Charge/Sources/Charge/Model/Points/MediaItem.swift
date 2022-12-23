//
//  MediaItem.swift
//  
//
//  Created by Александр Казак-Казакевич on 10.12.2022.
//

import Foundation

/// A struct representing a photo.
struct MediaItem {
    
    // MARK: Public Properties
    let url: URL
}

// MARK: - Codable
extension MediaItem: Codable {
    enum CodingKeys: String, CodingKey {
        case url = "ItemURL"
    }
}
