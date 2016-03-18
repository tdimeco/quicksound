//
//  Sound.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation


private let filePathKey = "filePath"


class Sound {
    
    var filePath: String
    
    
    // MARK: - Lifecycle
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    
    // MARK: - Binding to dictionary
    
    convenience init?(dictionary: NSDictionary) {
        guard let filePath = dictionary.valueForKey(filePathKey) as? String else { return nil }
        self.init(filePath: filePath)
    }
    
    func toDictionary() -> NSMutableDictionary {
        let dic = NSMutableDictionary()
        dic.setValue(self.filePath, forKey: filePathKey)
        return dic
    }
}
