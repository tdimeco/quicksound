//
//  AppDelegate.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa

// MARK: - AppDelegate

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: Properties
    
    private let statusItemController = StatusItemController()
    
    // MARK: Core Data
    
    static let storeUrl = AppDelegate.applicationDocumentsDirectory.appendingPathComponent("QuickSound.sqlite")
    static let modelUrl = Bundle.main.url(forResource: "Model", withExtension: "momd")!
    static let dataManager = DataManager(storeUrl: AppDelegate.storeUrl, andModelUrl:  AppDelegate.modelUrl)
    
    static var applicationDocumentsDirectory: URL = {
        
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let applicationSupportDirectoryURL = URL(fileURLWithPath:paths.first!, isDirectory: true)
        let appDirectory = applicationSupportDirectoryURL.appendingPathComponent("QuickSound", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true, attributes: nil)
        
        return appDirectory
        
    }()
    
    // MARK: Application delegate
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Matomo tracking
        Tracking.track(view: ["startup"])
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        
        // Save the Core Data context
        AppDelegate.dataManager.saveContext()
        
        // Matomo tracking
        Tracking.dispatch()
    }
}
