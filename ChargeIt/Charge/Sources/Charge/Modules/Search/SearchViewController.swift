//
//  SearchViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import UIKit
import MapKit
import SnapKit

class SearchViewController: UIViewController {
    
    // MARK: Private Properties
    private let presenter: SearchPresenterProtocol
    
    // MARK: Visual Components
    private var map: MKMapView = MKMapView()
    
    // MARK: Initializers
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = UIView()
        
        view.addSubview(map)
        
        map.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    
}
