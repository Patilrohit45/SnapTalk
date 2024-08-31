//
//  UserItem.swift
//  SnapTalk
//
//  Created by Rohit Patil on 27/08/24.
//

import Foundation

struct UserItem : Identifiable,Hashable,Decodable{
    let uid:String
    let username:String
    let email:String
    var bio:String? = nil
    var profileImageUrl:String? = nil
    
    var id:String{
        return uid
    }
        
    var bioUnwrapped:String{
        return bio ?? "Hey there! I am using SnapTalk"
    }
    
    static let placeholder = UserItem(uid: "1", username: "Hitman", email: "hitman@gmail.com")
    
    static let placeholders: [UserItem] = [
        UserItem(uid: "1", username: "Hitman", email: "hitman@gmail.com"),
        UserItem(uid: "2", username: "Rohit", email: "rp@gmail.com"),
        UserItem(uid: "3", username: "Shivraj", email: "Shivraj@gmail.com"),
        UserItem(uid: "4", username: "Om", email: "Om@gmail.com"),
        UserItem(uid: "5", username: "Avdhya", email: "Avdhya@gmail.com"),
        UserItem(uid: "6", username: "Aajya", email: "Aajya@gmail.com"),
        UserItem(uid: "8", username: "Amol", email: "Amol@gmail.com"),
        UserItem(uid: "9", username: "Harshya", email: "Harshya@gmail.com"),
        UserItem(uid: "10", username: "Vithu", email: "Vithu@gmail.com")
    ]
}

extension UserItem{
    init(dictionary:[String:Any]){
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? ""
        self.profileImageUrl = dictionary[.profileImageUrl] as? String ?? ""
    }
}

extension String{
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
