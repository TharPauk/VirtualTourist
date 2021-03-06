//
//  DataController.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 20/05/2021.
//

import Foundation
import CoreData

class DataController {
    
    // MARK: - Properties
    static let shared = DataController(modelName: "VirtualTourist")
    
    private let persistentContainer: NSPersistentContainer!
    var backgroundContext: NSManagedObjectContext!
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    // MARK: - Initialization
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    
    
    // MARK: - Config & Helper Functions
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error in loading Persistent Stores : \(error.localizedDescription)")
            }
            
            self.setupContexts()
            self.autoSaveViewContext()
            completion?()
        }
    }
    
    private func setupContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }
    
    private func autoSaveViewContext(interval: TimeInterval = 5) {
        guard interval > 0 else { return }
        
        saveContext()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
    
}
