//
//  TransformerIsChecked.swift
//  QuickSound
//
//  Created by playadz on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa


@objc(TransformerIsChecked)
class TransformerIsChecked: ValueTransformer {
    
    // MARK: - Value transformer
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let state = value as? Int else { return nil }
        return NSNumber(value: state == NSOnState)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let isOn = value as? NSNumber else { return nil }
        return isOn.boolValue ? NSOnState : NSOffState
    }
}
