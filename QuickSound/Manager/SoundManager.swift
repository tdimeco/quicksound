//
//  SoundManager.swift
//  QuickSound
//
//  Created by Nicolas HOAREAU on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import Cocoa

class SoundManager: NSObject, NSSoundDelegate {
    
    // MARK: Properties
    
    private var sounds: [NSSound] = []
    
    // MARK: Public API
    
    /// Use this method to play a sound.
    ///
    /// - Parameters:
    ///   - path: the path of the sound.
    ///   - repeatSound: a boolean to indicate if you want to repeat the sound.
    func playSound(atPath path: String, repeatSound: Bool) {
        
        guard let soundURL = URL(string: path) else { return }
        
        let sound = NSSound(contentsOf: soundURL, byReference: true)
        sound?.loops = repeatSound
        sound?.setName(NSSound.Name(path))
        
        let successOrNil = sound?.play()
        
        // Show alert
        if successOrNil == nil || !successOrNil! {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Alert.SoundError.Title", comment: "")
            alert.informativeText = NSLocalizedString("Alert.SoundError.Description", comment: "")
            alert.alertStyle = .critical
            alert.runModal()
        } else if repeatSound {
            self.sounds.append(sound!)
        }
    }
    
    /// Use this method to stop a sound.
    ///
    /// - Parameter path: the path of the sound.
    /// - Returns: a boolean to indicate if sound is stopped.
    @discardableResult
    func stopSound(atPath path: String) -> Bool {
        return self.removeSound(atPath: path)
    }
    
    /// Use this method to know if a sound if playing.
    ///
    /// - Parameter path: the path of the sound.
    /// - Returns: a boolean to indicate if sound is playing.
    func isSoundPlaying(atPath path: String) -> Bool {
        return self.sounds.contains { $0.name == NSSound.Name(path) }
    }
    
    // MARK: Private methods
    
    private func removeSound(atPath path: String) -> Bool {
        
        var stopped = false
        var indexToRemove: Int?
        
        for (index, sound) in self.sounds.enumerated() {
            if sound.name == NSSound.Name(path) {
                stopped = sound.stop()
                indexToRemove = index
                break
            }
        }
        
        if let indexToRemove = indexToRemove {
            self.sounds.remove(at: indexToRemove)
        }
        
        return stopped
    }
}
