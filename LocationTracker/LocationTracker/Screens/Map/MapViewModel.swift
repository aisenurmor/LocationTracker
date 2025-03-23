//
//  MapViewModel.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 21.03.2025.
//

import CoreLocation
import Foundation

final class MapViewModel {
    
    enum Change {
        case presentation([LocationModel])
        case didTrackingStatusChange(status: Bool)
        case didLocationUpdate(location: LocationModel)
        case didAuthorizationStatusChange(status: CLAuthorizationStatus)
        case alert(title: String, message: String, actions: [AlertAction]? = nil)
    }
    
    var changeHandler: ((Change) -> Void)?
    
    private(set) var locations: [LocationModel] = []
    private var isTracking: Bool = false
    
    private let locationRepository: LocationRepositoryProtocol
    
    init(_ locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
}

extension MapViewModel {
    func didTrackingButtonTap() {
        if isTracking {
            stopTracking()
        } else {
            startTracking()
        }
        changeHandler?(.didTrackingStatusChange(status: isTracking))
    }
    
    func didResetButtonTap() {
        changeHandler?(.alert(
            title: "Rotayı Sıfırla",
            message: "Tüm konum geçmişiniz silinecek. Devam etmek istiyor musunuz?",
            actions: [
                .init(title: "İptal", style: .cancel),
                .init(title: "Sil", style: .destructive, handler: {
                    // TODO: Add action
                })
            ]
        ))
    }
}

private extension MapViewModel {
    func startTracking() {
        locationRepository.startTracking()
        isTracking = true
    }
    
    func stopTracking() {
        locationRepository.stopTracking()
        isTracking = false
    }
}

// MARK: - LocationRepositoryDelegate
extension MapViewModel: LocationRepositoryDelegate {
    func locationRepository(_ repository: LocationRepository, didUpdateLocation location: LocationModel) {
        locations.append(location)
        changeHandler?(.didLocationUpdate(location: location))
    }
    
    func locationRepository(_ repository: LocationRepository, didFailLocation error: any Error) {
        changeHandler?(.alert(
            title: "Bir hata oluştu.",
            message: "Lütfen daha sonra tekrar deneyin."
        ))
    }
    
    func locationRepository(_ repository: LocationRepository, didChangeAuthorization status: CLAuthorizationStatus) {
        changeHandler?(.didAuthorizationStatusChange(status: status))
    }
}
