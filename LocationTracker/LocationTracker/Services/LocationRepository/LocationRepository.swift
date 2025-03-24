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
    private let locationStorageManager: LocationStorageProtocol
    
    private let geocoder = CLGeocoder()
    
    init(
        _ locationManager: LocationManagerProtocol,
        _ locationStorageManager: LocationStorageProtocol
    ) {
        self.locationManager = locationManager
        self.locationStorageManager = locationStorageManager
        
        self.locationManager.delegate = self
    }
    
    private func saveLocation(_ location: LocationModel) async {
        var locations = await getSavedLocations()
        locations.append(location)
        
        await locationStorageManager.saveLocation(location)
    }
}

// MARK: - LocationRepositoryProtocol
extension LocationRepository: LocationRepositoryProtocol {
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
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
    
    func getSavedLocations() async -> [LocationModel] {
        return await locationStorageManager.fetchLocations()
    }
    
    func resetLocations() async {
        await locationStorageManager.deleteLocations()
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
            
            Task {
                await self.saveLocation(locationModel)
                self.delegate?.locationRepository(self, didUpdateLocation: locationModel)
            }
        }
    }
    
    func locationManager(_ manager: LocationManagerProtocol, didFailLocation error: Error) {
        delegate?.locationRepository(self, didFailLocation: error)
    }
    
    func locationManager(_ manager: LocationManagerProtocol, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationRepository(self, didChangeAuthorization: status)
    }
}
