//
//  MessageItem.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MessageItem:Identifiable{
    let id : String
    let text:String
    let type:MessageType
    let ownerUid:String
    let timeStamp:Date
    
    var direction:MessageDirection{
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, text: "Hey Dear", type: .text, ownerUid: "1",timeStamp: Date())
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, text: "Hey Dude, what's up!", type: .text, ownerUid: "2",timeStamp: Date())
    
    var alignment:Alignment{
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment:HorizontalAlignment{
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor : Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    static let stubMessages:[MessageItem] = [
        MessageItem(id: UUID().uuidString, text: "Hey There", type: .text, ownerUid: "3",timeStamp: Date()),
        MessageItem(id: UUID().uuidString, text: "CheckOut this photo", type: .photo, ownerUid: "4",timeStamp: Date()),
        MessageItem(id: UUID().uuidString, text: "Hey Play this video", type: .video, ownerUid: "5",timeStamp: Date()),
        MessageItem(id: UUID().uuidString, text: "", type: .audio, ownerUid: "6",timeStamp: Date())

    ]
}

extension MessageItem{
    init(id:String,dict:[String:Any]){
        self.id = id
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
    }
}

extension String{
    static let text = "text"
    static let type = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
}
