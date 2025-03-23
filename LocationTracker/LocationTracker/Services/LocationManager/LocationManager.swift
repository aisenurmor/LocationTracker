//
//  LocationManager.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject {
    
    private enum Constants {
        static let minimumDistance: CLLocationDistance = 100
    }

    weak var delegate: LocationManagerDelegate?
    
    private var lastLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
}

private extension LocationManager {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = Constants.minimumDistance
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
    }
}

// MARK: - LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if let lastLocation, location.distance(from: lastLocation) < Constants.minimumDistance {
            let distance = location.distance(from: lastLocation)
            if distance < Constants.minimumDistance {
                return
            }
        }
        
        lastLocation = location
        delegate?.locationManager(self, didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailLocation error: any Error) {
        delegate?.locationManager(self, didFailLocation: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManager(self, didChangeAuthorization: status)
    }
}
