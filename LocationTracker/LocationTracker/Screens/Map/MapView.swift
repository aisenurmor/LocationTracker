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
        
        setupMapView()
        setupButtons()
        updateTrackingButton()
        bindViewModel()
    }
}

// MARK: - Setup UI
private extension MapView {
    
    func bindViewModel() {
        viewModel.changeHandler = { [weak self] change in
            DispatchQueue.main.async {
                self?.applyChange(change)
            }
        }
    }
    
    func applyChange(_ change: MapViewModel.Change) {
        switch change {
        case .presentation(let presentation):
            // TODO: Show recent locations
            break
        case .didTrackingStatusChange(let status):
            updateTrackingButton(status)
        case .didLocationUpdate(let location):
            didLocationUpdate(location: location)
        case .didAuthorizationStatusChange(let status):
            didAuthorizationStatusChange(status)
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

// MARK: - Private Methods
private extension MapView {
    
    func didLocationUpdate(location: LocationModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addMarkerForLocation(location)
            
            let camera = GMSCameraPosition.camera(
                withLatitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                zoom: 15.0
            )
            self.mapView.animate(to: camera)
        }
    }
    
    func addMarkerForLocation(_ location: LocationModel) {
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.map = mapView
        marker.userData = location
        markers.append(marker)
        
        if markers.count > 1 {
            let path = GMSMutablePath()
            markers.forEach { path.add($0.position) }
            
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .blue
            polyline.strokeWidth = 3.0
            polyline.map = mapView
        }
    }
    
    func didAuthorizationStatusChange(_ status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            switch status {
            case .denied, .restricted:
                // TODO: Show bottomsheet
                break
            default:
                break
            }
        }
    }
}
