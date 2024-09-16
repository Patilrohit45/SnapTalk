//
//  TimeInterval+Extentions.swift
//  SnapTalk
//
//  Created by Rohit Patil on 01/09/24.
//

import Foundation


extension TimeInterval {
    var formatElapsedTime: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60 // Change %60 to calculate seconds correctly
        return String(format: "%02d:%02d", minutes, seconds)
    }

    static var stubTimeInterval: TimeInterval {
        return TimeInterval()
    }
}

