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
