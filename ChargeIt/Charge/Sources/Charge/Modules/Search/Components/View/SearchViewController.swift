//
//  SearchViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 02.12.2022.
//

import UIKit
import MapKit
import SnapKit

/// View of the Search Module.
final class SearchViewController: UIViewController {
    
    // MARK: VIPER
    private let presenter: SearchViewToPresenterProtocol
    private var sideSheetVisible = false
    
    // MARK: Public Properties
    let hapticsGenerator: HapticsGeneratorProtocol
    
    // MARK: Visual Components
    private lazy var searchView = SearchView()
    var alert: AlertView?
    
    // MARK: Initializers
    init(presenter: SearchViewToPresenterProtocol, hapticsGenerator: HapticsGeneratorProtocol) {
        self.presenter = presenter
        self.hapticsGenerator = hapticsGenerator
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = searchView         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.map.delegate = self
        searchView.map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "point")
        
        searchView.nearbyButton.addTarget(self, action: #selector(nearbyButtonTapped), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(panSurfaceTapped))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sideSheetTranslationChanged(_:)))
        searchView.sideSheet.panSurface.addGestureRecognizer(tapRecognizer)
        searchView.sideSheet.panSurface.addGestureRecognizer(panRecognizer)
        searchView.sideSheet.radiusSlider.addTarget(self, action: #selector(radiusSliderValueChanged), for: .valueChanged)
        searchView.sideSheet.countryRestrictionControl.addTarget(self, action: #selector(countryRestrictionValueChanged), for: .valueChanged)
        searchView.sideSheet.usageTypeControl.addTarget(self, action: #selector(usageTypeValueChanged), for: .valueChanged)
        
        presenter.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchView.sideSheet.preferenceLabel.stopAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchView.sideSheet.preferenceLabel.resumeAnimation()
    }
    
    // MARK: Private Methods
    private func expandHideSideSheet(with duration: TimeInterval = 0.5) {
        if sideSheetVisible {
            searchView.sideSheet.offsetLayoutGuide.snp.removeConstraints()
            searchView.sideSheet.layoutOffsetGuide()
            searchView.sideSheet.panSurface.snp.makeConstraints { make in
                make.left.equalTo(view.snp.left)
            }
        } else {
            searchView.sideSheet.panSurface.snp.removeConstraints()
            searchView.sideSheet.layoutPanSurface()
            searchView.sideSheet.offsetLayoutGuide.snp.makeConstraints { make in
                make.right.equalTo(view.snp.left)
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut]) {
            self.searchView.sideSheet.transform = .identity
            self.view.layoutIfNeeded()
        }
        
        sideSheetVisible.toggle()
    }
}

// MARK: - Actions
extension SearchViewController {
    @objc private func nearbyButtonTapped() {
        presenter.loadNearbyPoints()
        if sideSheetVisible {
            expandHideSideSheet()
        }
    }
    
    @objc private func panSurfaceTapped() {
        expandHideSideSheet()
    }
    
    @objc private func sideSheetTranslationChanged(_ sender: UIPanGestureRecognizer) {
        guard sender.state != .ended else {
            let velocity = abs(sender.velocity(in: view).x)
            let position = abs(sender.translation(in: view).x)
            
            if position > searchView.sideSheet.frame.width / 2 {
                let completionDuration = min((position / searchView.sideSheet.frame.width) / velocity * 500, 0.7)
                expandHideSideSheet(with: completionDuration)
            } else if velocity > 1000 {
                let completionDuration = (position / searchView.sideSheet.frame.width) / velocity * 4000
                expandHideSideSheet(with: completionDuration)
            } else if position / searchView.sideSheet.frame.width * velocity > 100 {
                let completionDuration = (position / searchView.sideSheet.frame.width) / velocity * 2000
                expandHideSideSheet(with: completionDuration)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.searchView.sideSheet.transform = .identity
                }
            }
            return
        }
        
        searchView.sideSheet.transform = CGAffineTransform(translationX: sender.translation(in: view).x, y: 0)
    }
    
    @objc private func radiusSliderValueChanged() {
        presenter.radiusChanged(value: searchView.sideSheet.radiusSlider.value)
    }
    
    @objc private func countryRestrictionValueChanged() {
        presenter.countryRestrictionIndexChanged(to: searchView.sideSheet.countryRestrictionControl.selectedSegmentIndex)
    }
    
    @objc private func usageTypeValueChanged() {
        presenter.usageTypeIndexChanged(to: searchView.sideSheet.usageTypeControl.selectedSegmentIndex)
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func updateUI(with viewModel: SearchViewModel) {
        hapticsGenerator.prepare()
        searchView.map.removeAnnotations(searchView.map.annotations)
        
        for (index, location) in viewModel.locations.enumerated() {
            let annotation = IdentifiablePlacemark(coordinate: location, id: index)
            searchView.map.addAnnotation(annotation)
        }
        
        if !viewModel.locations.isEmpty {
            hapticsGenerator.notificationOccurred(.success)
        }
        
        searchView.map.setRegion(viewModel.region, animated: true)
    }
    
    func setLocation(enabled: Bool) {
        searchView.nearbyButton.isEnabled = enabled
        searchView.nearbyButton.setTitle(enabled ? "Find nearby" : "Enable location services", for: .disabled)
        searchView.nearbyButton.backgroundColor = searchView.nearbyButton.backgroundColor?.withAlphaComponent(enabled ? 1.0 : 0.5)
    }
    
    func updateRadius(with radius: Int) {
        searchView.sideSheet.radiusValueLabel.text = "\(radius) km"
    }
    
    func startActivityIndication() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
            self.searchView.activityIndicator.isHidden = false
            self.searchView.activityIndicator.transform = .identity
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut]) {
            self.searchView.activityIndicator.alpha = 1
        }
    }
    
    func stopActivityIndication() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut]) {
            self.searchView.activityIndicator.isHidden = true
            self.searchView.activityIndicator.alpha = 0
            self.searchView.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 0.5).concatenating(CGAffineTransform(translationX: self.searchView.activityIndicator.frame.width, y: 0))
        }
    }
    
    func lockRequests() {
        searchView.nearbyButton.isEnabled = false
    }
    
    func unlockRequests() {
        searchView.nearbyButton.isEnabled = true
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        presenter.mapRegionChanged(to: mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? IdentifiablePlacemark else {
            return
        }
        presenter.itemTapped(at: annotation.id)
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}

// MARK: - Alertable
extension SearchViewController: Alertable { }
