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
    private lazy var map: MKMapView = MKMapView()
    private lazy var nearbyButton: UIButton = {
        let button: UIButton
        button = UIButton(type: .custom)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        
        button.setTitle("Nearby Charging Points", for: .normal)
        button.setTitle("Enable Location Services", for: .disabled)
        button.isEnabled = false
        
        return button
    }()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
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
        
        map.addSubview(nearbyButton)
        nearbyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        nearbyButton.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            if let label = nearbyButton.titleLabel {
                make.trailing.equalTo(label.snp.leading).inset(-7)
            }
        }
        
        nearbyButton.titleLabel?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "point")
        
        nearbyButton.addTarget(self, action: #selector(nearbyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: Actions
    @objc private func nearbyButtonTapped() {
        presenter.loadNearbyPoints()
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
        self.present(ac, animated: true)
    }
    
    func setLocation(enabled: Bool) {
        nearbyButton.isEnabled = enabled
    }
    
    func startActivityIndication() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndication() {
        activityIndicator.stopAnimating()
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
