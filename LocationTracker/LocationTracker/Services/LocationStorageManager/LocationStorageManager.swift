//
//  LocationStorageManager.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 23.03.2025.
//

import CoreData
import Foundation

actor LocationStorageManager {
    
    static let shared = LocationStorageManager()
    
    private let modelName = "LocationDataModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    private init() {}
}

// MARK: - LocationStorageProtocol
extension LocationStorageManager: LocationStorageProtocol {
    
    func saveLocation(_ location: LocationModel) async {
        let context = persistentContainer.viewContext
        let dataModel = LocationDataModel(context: context)
        dataModel.latitude = location.coordinate.latitude
        dataModel.longitude = location.coordinate.longitude
        dataModel.timestamp = location.timestamp
        dataModel.address = location.address
        
        do {
            try context.save()
        } catch {
            debugPrint("Failed to save location: \(error)")
        }
    }
    
    func fetchLocations() async -> [LocationModel] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LocationDataModel> = LocationDataModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let locations = try context.fetch(fetchRequest)
            return locations.map { LocationModel($0) }
        } catch {
            debugPrint("Failed to fetch locations: \(error)")
            return []
        }
    }
    
    func deleteLocations() async {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LocationDataModel.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            debugPrint("Failed to delete locations: \(error)")
        }
    }
}

// MARK: - LocationModel Extension
private extension LocationModel {
    
    init(_ model: LocationDataModel) {
        self.init(
            coordinate: .init(
                latitude: model.latitude,
                longitude: model.longitude
            ),
            timestamp: model.timestamp ?? .now,
            address: model.address
        )
    }
}
