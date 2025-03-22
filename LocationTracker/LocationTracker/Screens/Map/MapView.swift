//
//  MapView.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 21.03.2025.
//

import GoogleMaps
import UIKit

final class MapView: UIViewController {
    
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
    }
}

// MARK: - Setup UI
private extension MapView {
    
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
    
    func updateTrackingButton() {
        let buttonImage = UIImage(systemName: viewModel.isTracking ? "pause.fill" : "play.fill")
        trackingButton.setImage(buttonImage, for: .normal)
        trackingButton.backgroundColor = viewModel.isTracking ? .systemBlue.withAlphaComponent(0.6) : .systemBlue
    }
    
    @objc private func trackingButtonTapped() {
        viewModel.trackingButtonTapped()
        updateTrackingButton()
    }
    
    @objc private func resetButtonTapped() {
        let alert = UIAlertController(
            title: "Rotayı Sıfırla",
            message: "Tüm konum geçmişiniz silinecek. Devam etmek istiyor musunuz?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { _ in
            // TODO: Add action
        })
        present(alert, animated: true)
    }
}
