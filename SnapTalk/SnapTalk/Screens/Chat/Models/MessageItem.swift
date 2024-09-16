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
    let isGroupChat:Bool
    let text:String
    let type:MessageType
    let ownerUid:String
    let timeStamp:Date
    var sender:UserItem?
    let thumbnailUrl: String?
    var thumbnailHeight:CGFloat?
    var thumbnailWidth:CGFloat?
    
    var direction:MessageDirection{
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hey Dear", type: .text, ownerUid: "1",timeStamp: Date(), thumbnailUrl: nil)
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString,isGroupChat: false,  text: "Hey Dude, what's up!", type: .text, ownerUid: "2",timeStamp: Date(), thumbnailUrl: nil)
    
    var alignment:Alignment{
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment:HorizontalAlignment{
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor : Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    var showGroupPartnerInfo:Bool{
        return isGroupChat && direction == .received
    }
    
    var leadingPadding:CGFloat{
        return direction == .received ? 0 : horizontalPadding
    }
    var trailingPadding:CGFloat{
        return direction == .received ? horizontalPadding : 0
    }
    
   private let horizontalPadding:CGFloat = 25
    
    var imageSize:CGSize{
        let photoWidth = thumbnailWidth ?? 0
        let photoHeight = thumbnailHeight ?? 0
        let imageHeight = CGFloat(photoWidth/photoHeight * imageWidth)
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    var imageWidth: CGFloat{
        let photoWidth = (UIWindowScene.current?.screenWidth ?? 0) / 1.5
        return photoWidth
    }
    
    static let stubMessages:[MessageItem] = [
        MessageItem(id: UUID().uuidString,isGroupChat: false,  text: "Hey There", type: .text, ownerUid: "3",timeStamp: Date(), thumbnailUrl: nil),
        MessageItem(id: UUID().uuidString,isGroupChat: true,  text: "CheckOut this photo", type: .photo, ownerUid: "4",timeStamp: Date(), thumbnailUrl: nil),
        MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hey Play this video", type: .video, ownerUid: "5",timeStamp: Date(), thumbnailUrl: nil),
        MessageItem(id: UUID().uuidString,isGroupChat: false,  text: "", type: .audio, ownerUid: "6",timeStamp: Date(), thumbnailUrl: nil)

    ]
}

extension MessageItem{
    init(id:String,isGroupChat:Bool,dict:[String:Any]){
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.thumbnailHeight = dict[.thumbnailHeight] as? CGFloat ?? 0
        self.thumbnailWidth = dict[.thumbnailWidth] as? CGFloat ?? 0

    }
}

extension String{
    static let text = "text"
    static let type = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let thumbnailWidth = "thumbnailWidth"
    static let thumbnailHeight = "thumbnailHeight"
}
