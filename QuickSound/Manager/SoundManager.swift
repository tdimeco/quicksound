//
//  SoundManager.swift
//  QuickSound
//
//  Created by Nicolas HOAREAU on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import Cocoa

class SoundManager {
    
    // MARK: Properties
    
    private var repeatingSounds: [(object: Sound, sound: NSSound)] = []
    
    // MARK: Lifecycle
    
    init(managedObjectContext: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectDidChanged(_:)), name: .NSManagedObjectContextObjectsDidChange, object: managedObjectContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Public API
    
    /// Use this method to play a sound.
    ///
    /// - Parameters:
    ///   - sound: the sound object.
    func playSound(_ object: Sound) {
        
        guard let filePath = object.filePath, let url = URL(string: filePath) else { return }
        
        let repeatSound = object.repeatEnabled?.boolValue ?? false
        let sound = NSSound(contentsOf: url, byReference: true)
        sound?.loops = repeatSound
        
        let successOrNil = sound?.play()
        
        // Show alert
        if successOrNil == nil || !successOrNil! {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Alert.SoundError.Title", comment: "")
            alert.informativeText = NSLocalizedString("Alert.SoundError.Description", comment: "")
            alert.alertStyle = .critical
            alert.runModal()
        } else if repeatSound {
            self.repeatingSounds.append((object, sound!))
        }
    }
    
    /// Use this method to stop a sound.
    ///
    /// - Parameter object: the sound object.
    /// - Returns: a boolean to indicate if sound is stopped.
    @discardableResult
    func stopSound(_ object: Sound) -> Bool {
        
        var stopped = false
        var indexToRemove: Int?
        
        for (index, tuple) in self.repeatingSounds.enumerated() {
            if tuple.object == object {
                stopped = tuple.sound.stop()
                indexToRemove = index
                break
            }
        }
        
        if let indexToRemove = indexToRemove {
            self.repeatingSounds.remove(at: indexToRemove)
        }
        
        return stopped
    }
    
    /// Use this method to know if a sound if playing.
    ///
    /// - Parameter object: the sound object.
    /// - Returns: a boolean to indicate if sound is playing.
    func isSoundPlaying(_ object: Sound) -> Bool {
        return self.repeatingSounds.contains { $0.object == object }
    }
    
    // MARK: Private methods
    
    @objc private func managedObjectDidChanged(_ notification: Notification) {
        
        let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<Sound> ?? []
        let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<Sound> ?? []
        let all = deleted + updated.filter { $0.repeatEnabled?.boolValue == false }
        
        // Try to stop all filtered sounds
        all.forEach {
            self.stopSound($0)
        }
    }
}
