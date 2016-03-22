//
//  TransformerFilePathToName.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation


@objc(TransformerFilePathToName)
class TransformerFilePathToName: NSValueTransformer {
    
    // MARK: - Value transformer
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let filePath = value as? String else { return nil }
        guard let lastPathComponent = NSURL(string: filePath)?.lastPathComponent else { return nil }
        return NSString(string: lastPathComponent).stringByDeletingPathExtension
    }
}
