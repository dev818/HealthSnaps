//
//  File.swift
//  HealthSnaps
//
//  Created by Admin on 16/04/2018.
//  Copyright © 2018 getHealthSnaps. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

public func checkMicPermission() -> Bool {
    
    var permissionCheck: Bool = false
    
    switch AVAudioSession.sharedInstance().recordPermission() {
    case AVAudioSessionRecordPermission.granted:
        permissionCheck = true
    case AVAudioSessionRecordPermission.denied:
        permissionCheck = false
    case AVAudioSessionRecordPermission.undetermined:
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            if granted {
                permissionCheck = true
            } else {
                permissionCheck = false
            }
        })
    }
    
    return permissionCheck
}
