//
//  LocationPermissionView.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 23.03.2025.
//

import UIKit

final class LocationPermissionView: UIView {

    // MARK: - UI Elements
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Konumunuzu harita üzerinde görüntülemek için konum izni gereklidir."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var enableLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Konumu Etkinleştir", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(openAppSettings), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension LocationPermissionView {
    
    func setupUI() {
        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [locationImageView, messageLabel, enableLocationButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        enableLocationButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            locationImageView.widthAnchor.constraint(equalToConstant: 80),
            locationImageView.heightAnchor.constraint(equalToConstant: 80),
            
            enableLocationButton.heightAnchor.constraint(equalToConstant: 44),
            enableLocationButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    @objc func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
}
