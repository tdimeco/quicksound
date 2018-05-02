//
//  Sound.swift
//  QuickSound
//
//  Created by Nicolas HOAREAU on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import CoreData

extension Sound {
    
    // MARK: Creation
    
    @discardableResult
    static func createSound(withPath filepath: String, inContext context: NSManagedObjectContext) -> Sound? {
        var object: Sound?
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Sound", in: context) {
            object = Sound(entity: entityDescription, insertInto: context)
            object?.filePath = filepath
            object?.name = Utils.filePathToFileNameWithoutExtension(filepath)
        }
        return object
    }
    
    // MARK: Sort descriptors
    
    static func alphabeticalSortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: "name", ascending: true)
    }
}
