//
//  StatusItemController.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa


class StatusItemController: NSObject {
    
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    
    
    // MARK: - Lifecycle
    
    override init() {
        
        // Create status item and popover
        self.statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        self.popover = NSPopover()
        super.init()
        
        // Setup status item
        let statusButton = self.statusItem.button!
        statusButton.title = "♬"
        statusButton.target = self
        statusButton.action = #selector(StatusItemController.statusItemClicked(_:))
        statusButton.sendAction(on: NSEventMask(rawValue: UInt64(NSEventMask.leftMouseUp.rawValue | NSEventMask.rightMouseUp.rawValue)))
        
        // Setup popover
        self.popover.behavior = .transient
        self.popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        self.popover.contentViewController = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
    }
    
    
    // MARK: - Status item
    
    func statusItemClicked(_ sender: AnyObject) {
        if self.popover.isShown {
            self.closePopover()
        } else {
            self.openPopover()
        }
    }
    
    
    // MARK: - Popover
    
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
