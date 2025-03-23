//
//  LocationRepository.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation

final class LocationRepository {
    
    weak var delegate: LocationRepositoryDelegate?
    
    private var locationManager: LocationManagerProtocol
    
    private let geocoder = CLGeocoder()
    
    init(_ locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
}

// MARK: - LocationRepositoryProtocol
extension LocationRepository: LocationRepositoryProtocol {
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocationPermission() {
        locationManager.requestAuthorization()
    }
    
    func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            let address = [placemark.locality, placemark.administrativeArea].compactMap { $0 }.joined(separator: ", ")
            completion(address)
        }
    }
}

// MARK: - LocationManagerDelegate
extension LocationRepository: LocationManagerDelegate {
    func locationManager(_ manager: LocationManagerProtocol, didUpdateLocation location: CLLocation) {
        let coordinate = location.coordinate
        
        reverseGeocode(location: location) { [weak self] address in
            guard let self = self else { return }
            
            let locationModel = LocationModel(
                coordinate: coordinate,
                timestamp: Date(),
                address: address
            )
            
            self.delegate?.locationRepository(self, didUpdateLocation: locationModel)
        }
    }
    
    func locationManager(_ manager: LocationManagerProtocol, didFailLocation error: Error) {
        delegate?.locationRepository(self, didFailLocation: error)
    }
    
    func locationManager(_ manager: LocationManagerProtocol, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationRepository(self, didChangeAuthorization: status)
    }
}
