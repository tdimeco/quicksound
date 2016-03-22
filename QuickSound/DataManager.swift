//
//  DataManager.swift
//  QuickSound
//
//  Created by playadz on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import CoreData


class DataManager {
    
    let managedObjectContext: NSManagedObjectContext
    let managedObjectModel: NSManagedObjectModel
    let storeCoordinator: NSPersistentStoreCoordinator
    
    /**
     DataManager initializer
     
     - parameter storeURL: the URL of the store
     - parameter modelUrl: the URL of the model
     
     - returns: A dataManager initialized
     */
    init(storeURL: NSURL, andModelURL modelUrl: NSURL) {
        
        // Init managed object model
        self.managedObjectModel = NSManagedObjectModel(contentsOfURL: modelUrl)!
        
        // Init store coordinator with managed object model
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try self.storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch let error as NSError {
            
            // Abort with error
            NSLog("Error when adding persistent store: %@", error)
            abort()
        }
        
        // Init managed object context
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
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
