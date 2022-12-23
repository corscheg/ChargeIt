//
//  SettingsViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 23.12.2022.
//

import UIKit

/// View of the Settings module.
final class SettingsViewController: UIViewController {

    // MARK: Private Properties
    private let presenter: SettingsPresenterProtocol
    private let settingsView = SettingsView()
    
    // MARK: Initializers
    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        let imageName: String
        
        if #available(iOS 14, *) {
            imageName = "gearshape.fill"
        } else {
            imageName = "gear"
        }
        
        tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: imageName), tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {
    
}
