//
//  StatusItemController.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa

class StatusItemController {
    
    // MARK: Properties
    
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    
    // MARK: Lifecycle
    
    init() {
        
        // Create status item and popover
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        self.popover = NSPopover()
        
        // Setup status item
        let statusButton = self.statusItem.button!
        statusButton.title = "♬"
        statusButton.target = self
        statusButton.action = #selector(statusItemClicked(_:))
        statusButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        // Setup popover
        self.popover.behavior = .transient
        self.popover.appearance = NSAppearance(named: .vibrantLight)
        self.popover.contentViewController = PopoverViewController(nibName: NSNib.Name("PopoverViewController"), bundle: nil)
    }
    
    // MARK: Status item
    
    @objc func statusItemClicked(_ sender: AnyObject) {
        if self.popover.isShown {
            self.closePopover()
        } else {
            self.openPopover()
        }
    }
    
    // MARK: Popover
    
    func openPopover() {
        
        // Show the popover
        self.popover.show(relativeTo: self.statusItem.button!.bounds, of: self.statusItem.button!, preferredEdge: .minY)
        
        // Give the focus to the app
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closePopover() {
        self.popover.close()
    }
}
