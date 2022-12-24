//
//  UserSettingsProtocol.swift
//  
//
//  Created by Александр Казак-Казакевич on 24.12.2022.
//

import Foundation

protocol UserSettingsProtocol {
    
    func updateMaxCount(to value: Int)
    
    func maxCount() -> Int
}
