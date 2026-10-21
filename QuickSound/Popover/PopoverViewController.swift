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
    @IBOutlet weak var moreMenu: NSMenu!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init array controller
        self.soundsArrayController.managedObjectContext = AppDelegate.dataManager.managedObjectContext
        self.soundsArrayController.sortDescriptors = [Sound.alphabeticalSortDescriptor()]
        self.soundsArrayController.prepareContent()
        
        // Add the sound output submenu, rebuilt each time it opens
        let outputMenu = NSMenu()
        outputMenu.delegate = self
        let outputItem = NSMenuItem(title: NSLocalizedString("Menu.SoundOutput", comment: ""), action: nil, keyEquivalent: "")
        outputItem.submenu = outputMenu
        self.moreMenu.insertItem(outputItem, at: 1)
        self.moreMenu.insertItem(.separator(), at: 2)
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
    
    @objc func selectOutputDevice(_ sender: NSMenuItem) {
        AudioOutputManager.selectedDeviceUID = sender.representedObject as? String
        self.soundManager.applyOutputDevice()
    }
    
    @IBAction func showAboutWindow(_ sender: AnyObject) {
        NSApplication.shared.orderFrontStandardAboutPanel(sender)
    }
    
    @IBAction func quitApplication(_ sender: AnyObject) {
        NSApplication.shared.terminate(sender)
    }
}

// MARK: - NSMenuDelegate

extension PopoverViewController: NSMenuDelegate {
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        let selectedUID = AudioOutputManager.effectiveDeviceUID
        menu.removeAllItems()
        
        // System default
        let defaultItem = NSMenuItem(title: NSLocalizedString("Menu.SoundOutput.SystemDefault", comment: ""), action: #selector(selectOutputDevice(_:)), keyEquivalent: "")
        defaultItem.target = self
        defaultItem.state = selectedUID == nil ? .on : .off
        menu.addItem(defaultItem)
        menu.addItem(.separator())
        
        // Output devices
        for device in AudioOutputManager.outputDevices() {
            let item = NSMenuItem(title: device.name, action: #selector(selectOutputDevice(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = device.uid
            item.state = device.uid == selectedUID ? .on : .off
            menu.addItem(item)
        }
    }
}
