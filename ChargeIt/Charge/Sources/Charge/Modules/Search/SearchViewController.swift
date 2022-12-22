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
    
    // MARK: Private Properties
    private let presenter: SearchViewToPresenterProtocol
    private var sideSheetVisible = false
    private let hapticsGenerator = UINotificationFeedbackGenerator()
    
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
    
    private lazy var sideSheet: PreferenceSideSheet = {
        let sheet = PreferenceSideSheet()
        
        return sheet
    }()
    
    // MARK: Initializers
    init(presenter: SearchViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
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
        activityIndicator.transform = activityIndicator.transform.concatenating(CGAffineTransform(translationX: activityIndicator.frame.width, y: 0))
        
        nearbyStack.addArrangedSubview(nearbyButton)
        nearbyButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        nearbyButton.titleLabel?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(sideSheet)
        sideSheet.snp.makeConstraints { make in
            make.bottom.equalTo(nearbyStack.snp.top).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
        
        sideSheet.panSurface.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
        }
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "point")
        
        nearbyButton.addTarget(self, action: #selector(nearbyButtonTapped), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(expandHideSideSheet))
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sideSheetTranslationChanged(_:)))
        sideSheet.panSurface.addGestureRecognizer(tapRecognizer)
        sideSheet.panSurface.addGestureRecognizer(panRecognizer)
        sideSheet.radiusSlider.addTarget(self, action: #selector(radiusSliderValueChanged), for: .valueChanged)
        sideSheet.countryRestrictionControl.addTarget(self, action: #selector(countryRestrictionValueChanged), for: .valueChanged)
        sideSheet.usageTypeControl.addTarget(self, action: #selector(usageTypeValueChanged), for: .valueChanged)
        
        presenter.viewDidLoad()
    }
    
    // MARK: Actions
    @objc private func nearbyButtonTapped() {
        presenter.loadNearbyPoints()
        if sideSheetVisible {
            expandHideSideSheet()
        }
    }
    
    @objc private func expandHideSideSheet() {
        if sideSheetVisible {
            sideSheet.offsetLayoutGuide.snp.removeConstraints()
            sideSheet.layoutOffsetGuide()
            sideSheet.panSurface.snp.makeConstraints { make in
                make.left.equalTo(view.snp.left)
            }
        } else {
            sideSheet.panSurface.snp.removeConstraints()
            sideSheet.layoutPanSurface()
            sideSheet.offsetLayoutGuide.snp.makeConstraints { make in
                make.right.equalTo(view.snp.left)
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.sideSheet.transform = .identity
            self.view.layoutIfNeeded()
        }
        
        sideSheetVisible.toggle()
    }
    
    @objc private func sideSheetTranslationChanged(_ sender: UIPanGestureRecognizer) {
        guard sender.state != .ended else {
            if abs(sender.translation(in: view).x) > sideSheet.frame.width / 2 {
                expandHideSideSheet()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.sideSheet.transform = .identity
                }
            }
            return
        }
        
        sideSheet.transform = CGAffineTransform(translationX: sender.translation(in: view).x, y: 0)
    }
    
    @objc private func radiusSliderValueChanged() {
        presenter.radiusChanged(value: sideSheet.radiusSlider.value)
    }
    
    @objc private func countryRestrictionValueChanged() {
        presenter.countryRestrictionIndexChanged(to: sideSheet.countryRestrictionControl.selectedSegmentIndex)
    }
    
    @objc private func usageTypeValueChanged() {
        presenter.usageTypeIndexChanged(to: sideSheet.usageTypeControl.selectedSegmentIndex)
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func updateUI(with viewModel: SearchViewModel) {
        hapticsGenerator.prepare()
        map.removeAnnotations(map.annotations)
        
        for (index, location) in viewModel.locations.enumerated() {
            let annotation = IdentifiablePlacemark(coordinate: location, id: index)
            map.addAnnotation(annotation)
        }
        
        if !viewModel.locations.isEmpty {
            hapticsGenerator.notificationOccurred(.success)
        }
        
        map.setRegion(viewModel.region, animated: true)
    }
    
    func showError(with message: String) {
        hapticsGenerator.prepare()
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        hapticsGenerator.notificationOccurred(.error)
        self.present(ac, animated: true)
    }
    
    func setLocation(enabled: Bool) {
        nearbyButton.isEnabled = enabled
        nearbyButton.setTitle(enabled ? "Find nearby" : "Enable location services", for: .disabled)
        nearbyButton.backgroundColor = nearbyButton.backgroundColor?.withAlphaComponent(enabled ? 1.0 : 0.5)
    }
    
    func updateParameters(with parameters: QueryParametersViewModel) {
        sideSheet.radiusValueLabel.text = "\(parameters.radius) km"
    }
    
    func startActivityIndication() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [.curveEaseInOut]) {
            self.activityIndicator.isHidden = false
            self.activityIndicator.transform = .identity
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut]) {
            self.activityIndicator.alpha = 1
        }
    }
    
    func stopActivityIndication() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut]) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.alpha = 0
            self.activityIndicator.transform = CGAffineTransform(scaleX: 1, y: 0.5).concatenating(CGAffineTransform(translationX: self.activityIndicator.frame.width, y: 0))
        }
    }
    
    func lockRequests() {
        nearbyButton.isEnabled = false
    }
    
    func unlockRequests() {
        nearbyButton.isEnabled = true
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
