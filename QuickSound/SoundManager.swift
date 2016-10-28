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
    
    private var sounds: [NSSound] = []
    
    
    /**
     Use this method to play a sound
     
     - parameter path: the path of the sound
     - parameter repeatSound: a boolean to indicate if you want repeat the sound
     */
    func playSound(atPath path: String, repeatSound: Bool) {
        
        if let soundURL = URL(string: path) {
            let sound = NSSound(contentsOf: soundURL, byReference: true)
            
            sound?.loops = repeatSound
            sound?.setName(path)
            
            let successOrNil = sound?.play()
            
            // Show alert
            if successOrNil == nil || !successOrNil! {
                let alert = NSAlert()
                alert.messageText = "Impossible de lire le son"
                alert.informativeText = "Le fichier est invalide ou introuvable."
                alert.alertStyle = .critical
                alert.runModal()
            } else if repeatSound {
                self.sounds.append(sound!)
            }
        }
    }
    
    /**
     Use this method to stop a sound
     
     - parameter path: the path of the sound
     
     - returns: A boolean to indicate if sound is stopped
     */
    func stopSound(atPath path: String) -> Bool {
        return self.removeSound(atPath: path)
    }
    
    /**
     Use this method to know if a sound if playing
     
     - parameter path: the path of the sound
     
     - returns: A boolean to indicate if sound is playing
     */
    func isSoundPlaying(atPath path: String) -> Bool {
        for sound in self.sounds {
            if sound.name == path {
                return true
            }
        }
        return false
    }
    
    // MARK: - Private
    
    private func removeSound(atPath path: String) -> Bool {
        var stopped = false
        var indexToRemove: Int?
        
        for (index, sound) in self.sounds.enumerated() {
            if sound.name == path {
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
