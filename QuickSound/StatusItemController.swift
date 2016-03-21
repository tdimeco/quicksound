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
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
        self.popover = NSPopover()
        super.init()
        
        // Setup status item
        let statusButton = self.statusItem.button!
        statusButton.title = "♬"
        statusButton.target = self
        statusButton.action = #selector(StatusItemController.statusItemClicked(_:))
        statusButton.sendActionOn(Int(NSEventMask.LeftMouseUpMask.rawValue | NSEventMask.RightMouseUpMask.rawValue))
        
        // Setup popover
        self.popover.behavior = .Transient
        self.popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        self.popover.contentViewController = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
    }
    
    
    // MARK: - Status item
    
    func statusItemClicked(sender: AnyObject) {
        if self.popover.shown {
            self.closePopover()
        } else {
            self.openPopover()
        }
    }
    
    
    // MARK: - Popover
    
    func openPopover() {
        
        // Show the popover
        self.popover.showRelativeToRect(self.statusItem.button!.bounds, ofView: self.statusItem.button!, preferredEdge: .MinY)
        
        // Give the focus to the app
        NSApp.activateIgnoringOtherApps(true)
    }
    
    func closePopover() {
        self.popover.close()
    }
}
