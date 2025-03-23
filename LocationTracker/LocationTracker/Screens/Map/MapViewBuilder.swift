//
//  MapViewBuilder.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

enum MapViewBuilder {
    
    static func build() -> MapView {
        let locationManager = LocationManager()
        let locationRepository = LocationRepository(locationManager)
        let viewModel = MapViewModel(locationRepository)
        locationRepository.delegate = viewModel
        return MapView(viewModel: viewModel)
    }
}
