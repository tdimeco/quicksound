//
//  PopoverViewController.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa


class PopoverViewController: NSViewController {
    
    @IBOutlet var soundsArrayController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    
    private let soundManager:SoundManager = SoundManager()
    
    // MARK: - Lifecycle
    
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
    
    
    // MARK: - UI actions
    
    @IBAction func tableViewRowDoubleClicked(tableView: NSTableView) {
        guard tableView.clickedRow >= 0 else { return }
        guard let arrangedObjects = self.soundsArrayController.arrangedObjects as? [AnyObject] else { return }
        guard let soundObject = arrangedObjects[tableView.clickedRow] as? Sound else { return }
        
        // Play sound
        let repeatEnabled = soundObject.repeatEnabled!.boolValue
        let filePath = soundObject.filePath!
        
        if repeatEnabled && self.soundManager.soundIsPlaying(filePath) {
            self.soundManager.stopSound(atPath: filePath)
        } else {
            self.soundManager.playSound(atPath: filePath, repeatSound: repeatEnabled)
        }
    }
    
    @IBAction func addSoundAction(sender: AnyObject) {
        
        // Configure open panel
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = true
        
        // Open panel
        let result = openPanel.runModal()
        if result == NSFileHandlingPanelOKButton {
            
            // Save each selected sound
            for fileURL in openPanel.URLs {
                let filePath = fileURL.absoluteString
                Sound.createSoundInContext(filePath, inMoc: AppDelegate.dataManager.managedObjectContext)
            }
            
            // Save the context
            AppDelegate.dataManager.saveContext()
        }
    }
    
    @IBAction func removeSoundAction(sender: AnyObject) {
        self.soundsArrayController.remove(sender)
        AppDelegate.dataManager.saveContext()
    }
    
    @IBAction func autoRepeatClicked(sender: AnyObject) {
        AppDelegate.dataManager.saveContext()
    }
    
    @IBAction func showAboutWindow(sender: AnyObject) {
        NSApplication.sharedApplication().orderFrontStandardAboutPanel(sender)
    }
    
    @IBAction func quitApplication(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
}
