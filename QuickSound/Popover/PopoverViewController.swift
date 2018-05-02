//
//  PopoverViewController.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
    
    // MARK: Properties
    
    private let soundManager = SoundManager(managedObjectContext: AppDelegate.dataManager.managedObjectContext)
    
    // MARK: Outlets
    
    @IBOutlet var soundsArrayController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init array controller
        self.soundsArrayController.managedObjectContext = AppDelegate.dataManager.managedObjectContext
        self.soundsArrayController.sortDescriptors = [Sound.alphabeticalSortDescriptor()]
        self.soundsArrayController.prepareContent()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        // Deselect table view
        self.tableView.deselectAll(nil)        
    }
    
    // MARK: UI actions
    
    @IBAction func tableViewRowDoubleClicked(_ tableView: NSTableView) {
        
        guard tableView.clickedRow >= 0 else { return }
        guard let arrangedObjects = self.soundsArrayController.arrangedObjects as? [Any] else { return }
        guard let soundObject = arrangedObjects[tableView.clickedRow] as? Sound else { return }
        
        // Play or stop the sound
        let repeatEnabled = soundObject.repeatEnabled?.boolValue ?? false
        if repeatEnabled && self.soundManager.isSoundPlaying(soundObject) {
            self.soundManager.stopSound(soundObject)
        } else {
            self.soundManager.playSound(soundObject)
        }
    }
    
    @IBAction func addSoundAction(_ sender: AnyObject) {
        
        // Configure open panel
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = true
        
        // Open panel
        let result = openPanel.runModal()
        if result == .OK {
            
            // Save each selected sound
            for fileURL in openPanel.urls {
                let filePath = fileURL.absoluteString
                Sound.createSound(withPath: filePath, inContext: AppDelegate.dataManager.managedObjectContext)
            }
            
            // Save the context
            AppDelegate.dataManager.saveContext()
        }
    }
    
    @IBAction func removeSoundAction(_ sender: AnyObject) {
        self.soundsArrayController.remove(sender)
        AppDelegate.dataManager.saveContext()
    }
    
    @IBAction func autoRepeatClicked(_ sender: AnyObject) {
        AppDelegate.dataManager.saveContext()
    }
    
    @IBAction func showAboutWindow(_ sender: AnyObject) {
        NSApplication.shared.orderFrontStandardAboutPanel(sender)
    }
    
    @IBAction func quitApplication(_ sender: AnyObject) {
        NSApplication.shared.terminate(sender)
    }
}
