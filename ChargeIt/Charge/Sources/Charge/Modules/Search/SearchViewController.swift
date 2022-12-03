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
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "point")
        presenter.loadPoints()
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func updateUI(with viewModel: SearchViewModel) {
        viewModel.locations.forEach {
            map.addAnnotation(MKPlacemark(coordinate: $0))
        }
        
        map.setRegion(viewModel.region, animated: true)
    }
    
    func showError(with message: String) {
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension SearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "point") as? MKMarkerAnnotationView else {
            return nil
        }
        
        annotationView.annotation = annotation
        annotationView.markerTintColor = .systemGreen
        annotationView.glyphImage = UIImage(systemName: "bolt.fill")
        annotationView.titleVisibility = .hidden
        
        return annotationView
    }
}
