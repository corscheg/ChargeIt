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
    private var currentMaxCount: MaxCount
    
    // MARK: Initializers
    private init() {
        let setting = userDefaults.integer(forKey: maxCountKey)
        if let settingMax = MaxCount(rawValue: setting) {
            currentMaxCount = settingMax
        } else {
            currentMaxCount = .fiveThousand
        }
    }
    
    func maxCount() -> MaxCount {
        currentMaxCount
    }
    
    func updateMaxCount(to value: MaxCount) {
        currentMaxCount = value
        userDefaults.set(currentMaxCount.rawValue, forKey: maxCountKey)
    }
}
