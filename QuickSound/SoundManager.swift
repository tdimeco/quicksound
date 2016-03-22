//
//  SoundManager.swift
//  QuickSound
//
//  Created by Nicolas HOAREAU on 22/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Foundation
import Cocoa

class SoundManager:NSObject, NSSoundDelegate {
    
    private var sounds:[NSSound] = []

    /**
     Use this method to play a sound
     
     - parameter atPath: the path of the sound
     - parameter repeatSound: a boolean to indicate if you want repeat the sound
     */
    func playSound(atPath path: String, repeatSound: Bool) {
        
        if let soundURL = NSURL(string: path) {
            let sound = NSSound(contentsOfURL: soundURL, byReference: true)
            
            sound?.loops = repeatSound
            sound?.setName(path)
            
            let successOrNil = sound?.play()
            
            // Show alert
            if successOrNil == nil || !successOrNil! {
                let alert = NSAlert()
                alert.messageText = "Impossible de lire le son"
                alert.informativeText = "Le fichier est invalide ou introuvable."
                alert.alertStyle = .CriticalAlertStyle
                alert.runModal()
            } else if repeatSound {
                self.sounds.append(sound!)
            }
        }
    }
    
    /**
     Use this method to stop a sound
     
     - parameter atPath: the path of the sound
     
     - returns: A boolean to indicate if sound is stopped
     */
    func stopSound(atPath path: String) -> Bool {
        
        return self.removeSound(path)
    }
    
    /**
     Use this method to know if a sound if playing
     
     - parameter name: the name of the sound

     - returns: A boolean to indicate if sound is playing
     */
    func soundIsPlaying(name: String) -> Bool {
        for sound: NSSound in self.sounds {
            if sound.name == name {
                return true
            }
        }
        return false
    }
    
    // MARK: - Private
    
    private func removeSound(name: String) -> Bool {
        var stopped = false
        let soundsArray  = NSArray(array:self.sounds)
        
        for (index, value) in soundsArray.enumerate() {
            let sound = value as! NSSound
            if sound.name == name {
                stopped = sound.stop()
                self.sounds.removeAtIndex(index)
            }
        }
        return stopped
    }

}