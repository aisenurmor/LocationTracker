//
//  LocationRepositoryProtocol.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation

protocol LocationRepositoryProtocol {
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func startTracking()
    func stopTracking()
    func requestLocationPermission()
    func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void)
    func getSavedLocations() async -> [LocationModel]
    func resetLocations() async
}
