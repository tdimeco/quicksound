//
//  Utils.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import MatomoTracker

struct Utils {
    
    static func filePathToFileNameWithoutExtension(_ filePath: String) -> String? {
        guard let lastPathComponent = URL(string: filePath)?.lastPathComponent else { return nil }
        return NSString(string: lastPathComponent).deletingPathExtension
    }
}

// MARK: - Matomo tracker

struct Tracking {
    
    static func track(view: [String]) {
        MatomoTracker.shared.track(view: view)
    }
    
    static func track(eventWithCategory category: String, action: String) {
        MatomoTracker.shared.track(eventWithCategory: category, action: action, name: nil, number: nil, url: nil)
    }
    
    static func dispatch() {
        MatomoTracker.shared.dispatch()
    }
}

extension MatomoTracker {
    static let shared = MatomoTracker(siteId: Constants.matomoSiteId, baseURL: Constants.matomoURL)
}
