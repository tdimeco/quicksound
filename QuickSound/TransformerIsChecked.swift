//
//  TransformerIsChecked.swift
//  QuickSound
//
//  Created by playadz on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa

@objc(TransformerIsChecked)
class TransformerIsChecked: NSValueTransformer {

    // MARK: - Value transformer
    
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let state = value as? Int else { return nil }
        return NSNumber(bool: state == NSOnState)
    }
    
    override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        guard let state = value as? Int else { return nil }
        return NSNumber(bool: state == NSOnState)
    }

    
}
