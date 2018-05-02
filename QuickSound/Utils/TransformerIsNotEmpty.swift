//
//  TransformerIsNotEmpty.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation

@objc(TransformerIsNotEmpty)
class TransformerIsNotEmpty: ValueTransformer {
    
    // MARK: Value transformer
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSNumber.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Any] else { return nil }
        return NSNumber(value: array.count > 0)
    }
}
