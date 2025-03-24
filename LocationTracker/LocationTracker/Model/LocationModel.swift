//
//  LocationModel.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import CoreLocation

struct LocationModel: Codable {
    
    let coordinate: CLLocationCoordinate2D
    let timestamp: Date
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case timestamp
        case address
    }
    
    init(coordinate: CLLocationCoordinate2D, timestamp: Date, address: String? = nil) {
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.address = address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(address, forKey: .address)
    }
}
