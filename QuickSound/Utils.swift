//
//  Utils.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation


struct Utils {
    
    static func filePathToFileNameWithoutExtension(_ filePath: String) -> String? {
        guard let lastPathComponent = URL(string: filePath)?.lastPathComponent else { return nil }
        return NSString(string: lastPathComponent).deletingPathExtension
    }
}
