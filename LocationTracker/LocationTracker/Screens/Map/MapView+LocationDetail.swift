//
//  MapView+LocationDetail.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 23.03.2025.
//

import UIKit

extension MapView {
    
    func showDetail(of location: LocationModel) {
        let contentView = createMarkerDetailView(for: location)
        let bottomSheet = BottomSheetViewController(contentView: contentView)
        
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in 100 })]
            sheet.prefersGrabberVisible = false
        }
        
        present(bottomSheet, animated: true)
    }
    
    private func createMarkerDetailView(for location: LocationModel) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Konum Detayları"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        let locationLabel = UILabel()
        locationLabel.text = "Latitude: \(location.coordinate.latitude.formatted()) - Longitude: \(location.coordinate.longitude.formatted())"
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = .darkGray
        locationLabel.numberOfLines = 0
        locationLabel.setContentHuggingPriority(.required, for: .vertical)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = location.address
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, locationLabel, descriptionLabel, spacerView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        return container
    }
}
