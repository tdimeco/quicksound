//
//  Sound.swift
//  QuickSound
//
//  Created by playadz on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import CoreData


class Sound: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    static func createSoundInContext(filepath: String, inMoc moc: NSManagedObjectContext) -> Sound? {
        var object: Sound?
        
        if let entityDescription = NSEntityDescription.entityForName("Sound", inManagedObjectContext: moc) {
            object = Sound(entity: entityDescription, insertIntoManagedObjectContext: moc)
            object?.filePath = filepath
        }
        return object
    }
    
}
