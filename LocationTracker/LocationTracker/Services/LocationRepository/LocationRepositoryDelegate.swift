//
//  LocationRepositoryDelegate.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation

protocol LocationRepositoryDelegate: AnyObject {
    func locationRepository(_ repository: LocationRepository, didUpdateLocation location: LocationModel)
    func locationRepository(_ repository: LocationRepository, didFailLocation error: Error)
    func locationRepository(_ repository: LocationRepository, didChangeAuthorization status: CLAuthorizationStatus)
}
