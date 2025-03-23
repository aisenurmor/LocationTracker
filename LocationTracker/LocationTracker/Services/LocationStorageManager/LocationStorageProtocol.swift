//
//  LocationStorageProtocol.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 23.03.2025.
//

protocol LocationStorageProtocol {
    func saveLocation(_ location: LocationModel) async
    func fetchLocations() async -> [LocationModel]
    func deleteLocations() async
}
