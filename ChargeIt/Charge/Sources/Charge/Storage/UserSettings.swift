//
//  UserSettings.swift
//  
//
//  Created by Александр Казак-Казакевич on 24.12.2022.
//

import Foundation

/// A facade for `UserDefaults`.
final class UserSettings: UserSettingsProtocol {
    
    // MARK: Static Properties
    static let shared = UserSettings()
    
    // MARK: Public Properties
    let userDefaults = UserDefaults.standard
    
    // MARK: Private Properties
    private let maxCountKey = "maxCount"
    private var currentMaxCount: Int
    
    // MARK: Initializers
    private init() {
        currentMaxCount = userDefaults.integer(forKey: maxCountKey)
        if currentMaxCount == 0 {
            currentMaxCount = 5000
        }
    }
    
    func maxCount() -> Int {
        currentMaxCount
    }
    
    func updateMaxCount(to value: Int) {
        currentMaxCount = value
        userDefaults.set(currentMaxCount, forKey: maxCountKey)
    }
}
