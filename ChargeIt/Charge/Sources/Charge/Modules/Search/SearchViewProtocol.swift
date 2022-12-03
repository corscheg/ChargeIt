//
//  File.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func updateUI(with viewModel: SearchViewModel)
    func showError(with message: String)
}
