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
        button.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        
        button.setTitle("Find Nearby", for: .normal)
        button.setTitle("Enable Location Services", for: .disabled)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var nearbyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        return stack
    }()
    
    private lazy var activityIndicator: ExtendedActivityView = {
        let indicator = ExtendedActivityView()
        indicator.isHidden = true
        indicator.alpha = 0
        indicator.transform = CGAffineTransform(scaleX: 1, y: 0.5)
        
        return indicator
    }()
    
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
        
        map.addSubview(nearbyStack)
        nearbyStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        nearbyStack.addArrangedSubview(activityIndicator)
        
        nearbyStack.addArrangedSubview(nearbyButton)
        nearbyButton.snp.makeConstraints { make in
            make.height.equalTo(44)
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
        nearbyButton.backgroundColor = nearbyButton.backgroundColor?.withAlphaComponent(enabled ? 1.0 : 0.5)
    }
    
    func startActivityIndication() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
            self.activityIndicator.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut]) {
            self.activityIndicator.alpha = 1
            self.activityIndicator.transform = .identity
        }
    }
    
    func stopActivityIndication() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut]) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.alpha = 0
            self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 0.5)
        }
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
