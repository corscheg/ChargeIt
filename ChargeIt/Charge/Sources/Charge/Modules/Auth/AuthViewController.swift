//
//  AuthViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import UIKit

/// View of the Detail Point module.
final class AuthViewController: UIViewController {

    // MARK: VIPER
    private let presenter: AuthViewToPresenterProtocol
    
    // MARK: Visual Components
    private let authView = AuthView()
    
    // MARK: Initializers
    init(presenter: AuthViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = AuthView()
    }
}

// MARK: - AuthViewProtocol
extension AuthViewController: AuthViewProtocol {
    
}
