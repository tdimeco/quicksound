//
//  AudioOutputManager.swift
//  QuickSound
//
//  Created by Nicolas HOAREAU on 21/10/2026.
//  Copyright © 2026 Thomas Di Meco. All rights reserved.
//

import Foundation
import CoreAudio

struct AudioOutputDevice: Sendable {
    let uid: String
    let name: String
}

enum AudioOutputManager {

    // MARK: Selection

    /// The UID of the output device chosen by the user, or `nil` for the system default.
    static var selectedDeviceUID: String? {
        get { UserDefaults.standard.string(forKey: Constants.selectedOutputDeviceUIDKey) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.selectedOutputDeviceUIDKey) }
    }

    /// The UID to play sounds on: the selected device if it is connected, `nil` (system default) otherwise.
    static var effectiveDeviceUID: String? {
        guard let uid = self.selectedDeviceUID else { return nil }
        return self.outputDevices().contains { $0.uid == uid } ? uid : nil
    }

    // MARK: Devices

    /// Use this method to list the audio devices that can play sound.
    ///
    /// - Returns: the output devices, sorted by name.
    static func outputDevices() -> [AudioOutputDevice] {

        var address = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDevices, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
        var size: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size) == noErr else { return [] }

        var deviceIDs = [AudioDeviceID](repeating: 0, count: Int(size) / MemoryLayout<AudioDeviceID>.size)
        guard AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &deviceIDs) == noErr else { return [] }

        return deviceIDs
            .filter { self.hasOutputStreams($0) }
            .compactMap { deviceID in
                guard let uid = self.stringProperty(kAudioDevicePropertyDeviceUID, of: deviceID),
                      let name = self.stringProperty(kAudioObjectPropertyName, of: deviceID) else { return nil }
                return AudioOutputDevice(uid: uid, name: name)
            }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    // MARK: Private methods

    private static func hasOutputStreams(_ deviceID: AudioDeviceID) -> Bool {
        var address = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyStreams, mScope: kAudioObjectPropertyScopeOutput, mElement: kAudioObjectPropertyElementMain)
        var size: UInt32 = 0
        return AudioObjectGetPropertyDataSize(deviceID, &address, 0, nil, &size) == noErr && size > 0
    }

    private static func stringProperty(_ selector: AudioObjectPropertySelector, of deviceID: AudioDeviceID) -> String? {
        var address = AudioObjectPropertyAddress(mSelector: selector, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMain)
        var value: Unmanaged<CFString>?
        var size = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
        guard AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &value) == noErr else { return nil }
        return value?.takeRetainedValue() as String?
    }
}
