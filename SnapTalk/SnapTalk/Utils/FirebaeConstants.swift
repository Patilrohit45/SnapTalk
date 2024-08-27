//
//  FirebaeConstants.swift
//  SnapTalk
//
//  Created by Rohit Patil on 27/08/24.
//

import Foundation
import Firebase
import FirebaseStorage


enum FirebaeConstants{
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
}
