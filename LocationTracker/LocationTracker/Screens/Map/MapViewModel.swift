//
//  MapViewModel.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 21.03.2025.
//

import Foundation

final class MapViewModel {
    
    private(set) var isTracking: Bool = false
    
    init() { }
}

extension MapViewModel {
    
    func trackingButtonTapped() {
        isTracking.toggle()
    }
}
