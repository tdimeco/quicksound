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
    private weak var renamingTextField: NSTextField?
    
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
        
        // Add the row context menu
        let contextMenu = NSMenu()
        contextMenu.delegate = self
        contextMenu.autoenablesItems = false
        let renameItem = NSMenuItem(title: NSLocalizedString("Menu.Rename", comment: ""), action: #selector(renameSoundAction(_:)), keyEquivalent: "")
        renameItem.target = self
        contextMenu.addItem(renameItem)
        let removeItem = NSMenuItem(title: NSLocalizedString("Menu.Remove", comment: ""), action: #selector(removeClickedSoundAction(_:)), keyEquivalent: "")
        removeItem.target = self
        contextMenu.addItem(removeItem)
        self.tableView.menu = contextMenu
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        // Commit a rename in progress
        if self.renamingTextField != nil {
            self.view.window?.makeFirstResponder(nil)
        }
        
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
    
    @objc func removeClickedSoundAction(_ sender: AnyObject) {
        guard let soundObject = self.sound(atRow: self.tableView.clickedRow) else { return }
        self.soundsArrayController.removeObject(soundObject)
        AppDelegate.dataManager.saveContext()
    }
    
    @objc func renameSoundAction(_ sender: AnyObject) {
        self.beginRenaming(row: self.tableView.clickedRow)
    }
    
    override func keyDown(with event: NSEvent) {
        
        // Return renames the selected sound
        if event.keyCode == 36 || event.keyCode == 76, self.tableView.selectedRow >= 0 {
            self.beginRenaming(row: self.tableView.selectedRow)
        } else {
            super.keyDown(with: event)
        }
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
    
    // MARK: Private methods
    
    private func sound(atRow row: Int) -> Sound? {
        guard row >= 0, let arrangedObjects = self.soundsArrayController.arrangedObjects as? [Any], row < arrangedObjects.count else { return nil }
        return arrangedObjects[row] as? Sound
    }
    
    private func beginRenaming(row: Int) {
        guard let cellView = self.tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? NSTableCellView else { return }
        guard let textField = cellView.textField else { return }
        
        // Make the name field editable until editing ends
        textField.isEditable = true
        textField.delegate = self
        self.renamingTextField = textField
        self.view.window?.makeFirstResponder(textField)
        textField.currentEditor()?.selectAll(nil)
    }
}

// MARK: - NSTextFieldDelegate

extension PopoverViewController: NSTextFieldDelegate {
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        // Escape cancels the rename
        if commandSelector == #selector(NSResponder.cancelOperation(_:)) {
            control.abortEditing()
            self.endRenaming(control as? NSTextField)
            return true
        }
        return false
    }
    
    func controlTextDidEndEditing(_ notification: Notification) {
        
        let textField = notification.object as? NSTextField
        guard let cellView = textField?.superview as? NSTableCellView, let soundObject = cellView.objectValue as? Sound else { return }
        
        // An empty name falls back to the file name
        let name = soundObject.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if name.isEmpty, let filePath = soundObject.filePath {
            soundObject.name = Utils.filePathToFileNameWithoutExtension(filePath)
        } else if name != soundObject.name {
            soundObject.name = name
        }
        
        self.endRenaming(textField)
        AppDelegate.dataManager.saveContext()
        self.soundsArrayController.rearrangeObjects()
    }
    
    private func endRenaming(_ textField: NSTextField?) {
        textField?.isEditable = false
        self.renamingTextField = nil
        self.view.window?.makeFirstResponder(self.tableView)
    }
}

// MARK: - NSMenuDelegate

extension PopoverViewController: NSMenuDelegate {
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        // Row context menu: only enabled on a row
        if menu === self.tableView.menu {
            let hasClickedRow = self.tableView.clickedRow >= 0
            menu.items.forEach { $0.isEnabled = hasClickedRow }
            return
        }
        
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
