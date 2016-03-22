//
//  Sound+CoreDataProperties.swift
//  QuickSound
//
//  Created by playadz on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sound {

    @NSManaged var filePath: String?
    @NSManaged var repeatEnabled: NSNumber?

}
