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
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            try self.storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        // Init managed object context
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator
        
    }
    
    func createContextFromMainQueue() -> NSManagedObjectContext {
        
        let managedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedContext.persistentStoreCoordinator = self.storeCoordinator
        
        return managedContext
        
    }
    
    func saveContext () {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

