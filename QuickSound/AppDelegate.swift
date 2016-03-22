//
//  AppDelegate.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static let storeUrl = AppDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("QuickSound.sqlite")
    static let modelUrl = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
    static let dataManager: DataManager = DataManager(storeURL: AppDelegate.storeUrl, andModelURL:  AppDelegate.modelUrl)
    private let statusItemController = StatusItemController()
    
    static var applicationDocumentsDirectory: NSURL = {
        
        let fm = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
        let applicationSupportDirectoryURL = NSURL(fileURLWithPath:paths.first!, isDirectory:true)
        let appDirectory = applicationSupportDirectoryURL.URLByAppendingPathComponent("QuickSound", isDirectory:true)
        
        _ = try? fm.createDirectoryAtURL(appDirectory, withIntermediateDirectories: true, attributes: nil)
        
        return appDirectory

    }()
    
    // MARK: - Application delegate
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}
