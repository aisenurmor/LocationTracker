//
//  LocationManagerDelegate.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManagerProtocol, didUpdateLocation location: CLLocation)
    func locationManager(_ manager: LocationManagerProtocol, didFailLocation error: Error)
    func locationManager(_ manager: LocationManagerProtocol, didChangeAuthorization status: CLAuthorizationStatus)
}
