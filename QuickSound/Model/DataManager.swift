//
//  DataManager.swift
//  QuickSound
//
//  Created by Nicolas HOAREAU on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    // MARK: Properties
    
    let managedObjectContext: NSManagedObjectContext
    let managedObjectModel: NSManagedObjectModel
    let storeCoordinator: NSPersistentStoreCoordinator
    
    // MARK: Methods
    
    /// DataManager initializer.
    ///
    /// - Parameters:
    ///   - storeUrl: the URL of the store.
    ///   - modelUrl: the URL of the model.
    init(storeUrl: URL, andModelUrl modelUrl: URL) {
        
        // Init managed object model
        self.managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl)!
        
        // Init store coordinator with managed object model
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try self.storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch let error as NSError {
            
            // Abort with error
            NSLog("Error when adding persistent store: %@", error)
            abort()
        }
        
        // Init managed object context
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator
        
    }
    
    func saveContext () {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                
                // Abort with error
                NSLog("Error when saving the managed object context: %@", error)
                abort()
            }
        }
    }
}
