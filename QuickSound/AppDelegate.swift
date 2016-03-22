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
    
    // MARK: - Core Data
    
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
        
        // Check for updates
        self.checkForUpdates()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        
        // Save the Core Data context
        AppDelegate.dataManager.saveContext()
    }
    
    
    // MARK: - Updates
    
    func checkForUpdates() {
        
        // Check for updates in background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            // Get local/remote infos
            let localPlist = NSBundle.mainBundle().infoDictionary
            let remotePlist = NSDictionary(contentsOfURL: NSURL(string: Constants.UpdatePlistURL)!)
            
            // Check new version
            if let localVersion = localPlist?["CFBundleVersion"] as? String, remoteVersion = remotePlist?["CFBundleVersion"] as? String {
                if remoteVersion > localVersion {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showUpdatesAlert()
                    }
                }
            }
        }
    }
    
    private func showUpdatesAlert() {
        
        let alert = NSAlert()
        alert.messageText = "Une nouvelle version est disponible !"
        alert.informativeText = "Vous pouvez la télécharger la nouvelle version de QuickSound depuis GitHub."
        alert.alertStyle = .InformationalAlertStyle
        alert.addButtonWithTitle("Télécharger")
        alert.addButtonWithTitle("Pas maintenant")
        
        let result = alert.runModal()
        if result == NSAlertFirstButtonReturn {
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: Constants.UpdatesPageURL)!)
        }
    }
}
