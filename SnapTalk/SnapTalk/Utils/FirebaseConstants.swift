//
//  FirebaeConstants.swift
//  SnapTalk
//
//  Created by Rohit Patil on 27/08/24.
//

import Foundation
import Firebase
import FirebaseStorage


enum FirebaseConstants{
    static let StorageRef = Storage.storage().reference()
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
    static let ChannelRef = DatabaseRef.child("channels")
    static let MessageRef = DatabaseRef.child("channel-messages")
    static let UserChannelRef = DatabaseRef.child("user-channels")
    static let UserDirectChannels = DatabaseRef.child("user-direct-channels")
}
