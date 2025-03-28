//
//  MapView.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 21.03.2025.
//

import GoogleMaps
import UIKit

final class MapView: BaseViewController {
    
    private enum Constants {
        static let buttonHeight: CGFloat = 50
    }
    
    // MARK: - UI Elements
    private lazy var trackingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.buttonHeight/2
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(trackingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(systemName: "eraser.fill")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = Constants.buttonHeight/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var mapView: GMSMapView!
    private var markers: [GMSMarker] = []
    
    // MARK: - Properties
    private let viewModel: MapViewModel
    
    // MARK: - Initializer
    init(viewModel: MapViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addObserver()
        setupMapView()
        setupButtons()
        updateTrackingButton()
        bindViewModel()
    }
    
    @objc private func appDidBecomeActive() {
        viewModel.checkAuthorizationStatus()
    }
}

// MARK: - Setup UI
private extension MapView {
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    func bindViewModel() {
        viewModel.changeHandler = { [weak self] change in
            DispatchQueue.main.async {
                self?.applyChange(change)
            }
        }
    }
    
    func applyChange(_ change: MapViewModel.Change) {
        switch change {
        case .presentation(let locations):
            loadSavedLocations(locations)
        case .didTrackingStatusChange(let status):
            updateTrackingButton(status)
        case .didLocationUpdate(let location):
            didLocationUpdate(location: location)
        case .handleAuthorizationStatus(let status):
            handleAuthorizationStatus(status)
        case .alert(let title, let message, let actions):
            showAlert(with: title, message: message, actions: actions)
        }
    }
    
    func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1)
        
        let options = GMSMapViewOptions()
        options.camera = camera
        options.frame = view.bounds
        
        mapView = GMSMapView(options: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func setupButtons() {
        let stackView = UIStackView(arrangedSubviews: [trackingButton, resetButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            trackingButton.widthAnchor.constraint(equalToConstant: Constants.buttonHeight),
            trackingButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    func updateTrackingButton(_ isTracking: Bool = false) {
        let buttonImage = UIImage(systemName: isTracking ? "pause.fill" : "play.fill")
        trackingButton.setImage(buttonImage, for: .normal)
        trackingButton.backgroundColor = isTracking ? .systemBlue.withAlphaComponent(0.6) : .systemBlue
    }
    
    @objc func trackingButtonTapped() {
        viewModel.didTrackingButtonTap()
    }
    
    @objc func resetButtonTapped() {
        viewModel.didResetButtonTap()
    }
}

// MARK: - GMSMapViewDelegate
extension MapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let location = marker.userData as? LocationModel {
            showDetail(of: location)
        }
        return true
    }
}

// MARK: - Private Methods
private extension MapView {
    
    func loadSavedLocations(_ locations: [LocationModel]) {
        guard !locations.isEmpty else {
            clearMap()
            return
        }
        
        clearMap()
        locations.forEach { location in
            addMarkerForLocation(location)
        }
        
        if let lastLocation = locations.last {
            moveCamera(to: lastLocation.coordinate)
        }
    }
    
    func didLocationUpdate(location: LocationModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            addMarkerForLocation(location)
            moveCamera(to: location.coordinate)
        }
    }
    
    func moveCamera(to coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: 15.0
        )
        self.mapView.animate(to: camera)
    }
    
    func addMarkerForLocation(_ location: LocationModel) {
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.map = mapView
        marker.userData = location
        markers.append(marker)
    }
    
    func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            switch status {
            case .denied, .restricted:
                self.showAutorizationView()
            default:
                if self.presentedViewController is BottomSheetViewController {
                    self.presentedViewController?.dismiss(animated: false)
                }
            }
        }
    }
    
    func showAutorizationView() {
        let contentView = LocationPermissionView()
        let bottomSheet = BottomSheetViewController(contentView: contentView)
        
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.large()]
        }
        bottomSheet.isModalInPresentation = true
        self.present(bottomSheet, animated: true)
    }
    
    func clearMap() {
        mapView.clear()
        markers.removeAll()
    }
}
