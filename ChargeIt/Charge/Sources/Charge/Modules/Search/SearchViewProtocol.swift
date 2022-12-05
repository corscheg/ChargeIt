//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func startActivityIndication()
    func stopActivityIndication()
    func updateUI(with viewModel: SearchViewModel)
    func updateParameters(with viewModel: SearchViewModel)
    func showError(with message: String)
    func setLocation(enabled: Bool)
}
