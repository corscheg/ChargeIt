//
//  StorageError.swift
//  
//
//  Created by Александр Казак-Казакевич on 14.12.2022.
//

import Foundation

/// An error that may be thrown after Core Data failure.
enum StorageError: Error {
    case savingFailed
    case internalError
}
