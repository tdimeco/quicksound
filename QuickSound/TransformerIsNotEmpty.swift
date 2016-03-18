//
//  TransformerIsNotEmpty.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation


@objc(TransformerIsNotEmpty)
class TransformerIsNotEmpty: NSValueTransformer {
    
    // MARK: - Value transformer
    
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let array = value as? [AnyObject] else { return nil }
        return NSNumber(bool: array.count > 0)
    }
}
