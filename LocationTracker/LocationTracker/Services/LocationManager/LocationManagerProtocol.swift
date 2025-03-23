//
//  LocationManagerProtocol.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation

protocol LocationManagerProtocol {
    var delegate: LocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestAuthorization()
}
