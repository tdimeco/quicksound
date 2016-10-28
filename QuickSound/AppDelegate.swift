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
    
    private let statusItemController = StatusItemController()
    
    
    // MARK: - Core Data
    
    static let storeUrl = AppDelegate.applicationDocumentsDirectory.appendingPathComponent("QuickSound.sqlite")
    static let modelUrl = Bundle.main.url(forResource: "Model", withExtension: "momd")!
    static let dataManager = DataManager(storeUrl: AppDelegate.storeUrl, andModelUrl:  AppDelegate.modelUrl)
    
    static var applicationDocumentsDirectory: URL = {
        
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let applicationSupportDirectoryURL = URL(fileURLWithPath:paths.first!, isDirectory: true)
        let appDirectory = applicationSupportDirectoryURL.appendingPathComponent("QuickSound", isDirectory: true)
        
        _ = try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true, attributes: nil)
        
        return appDirectory
        
    }()
    
    
    // MARK: - Application delegate
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Check for updates
        self.checkForUpdates()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        
        // Save the Core Data context
        AppDelegate.dataManager.saveContext()
    }
    
    
    // MARK: - Updates
    
    func checkForUpdates() {
        
        // Check for updates in background
        DispatchQueue.global(qos: .utility).async {
            
            // Get local/remote infos
            let localPlist = Bundle.main.infoDictionary
            let remotePlist = NSDictionary(contentsOf: Constants.UpdatePlistURL)
            
            // Check new version
            if let localVersion = localPlist?["CFBundleVersion"] as? String, let remoteVersion = remotePlist?["CFBundleVersion"] as? String {
                if remoteVersion > localVersion {
                    DispatchQueue.main.async {
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
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Télécharger")
        alert.addButton(withTitle: "Pas maintenant")
        
        let result = alert.runModal()
        if result == NSAlertFirstButtonReturn {
            NSWorkspace.shared().open(Constants.UpdatesPageURL)
        }
    }
}
