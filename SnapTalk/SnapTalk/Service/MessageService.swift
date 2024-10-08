//
//  MessageService.swift
//  SnapTalk
//
//  Created by Rohit Patil on 01/09/24.
//

import Foundation
import Firebase

// MARK: Handles sending and fetching messages and setting reactions
struct MessageService{
    
    
    static func sendTextMessage(to channel:ChannelItem, from currentUser:UserItem, _ textMessage:String,onComplete: () -> Void){
        let timeStamp = Date().timeIntervalSince1970
        guard let messageId = FirebaseConstants.MessageRef.childByAutoId().key else { return }
        
        let channelDict : [String:Any] = [
            .lastMessage : textMessage,
            .lastMessageTimeStamp:timeStamp
        ]
        
        let messageDict : [String:Any] = [
            .text: textMessage,
            .type: MessageType.text.title,
            .timeStamp: timeStamp,
            .ownerUid : currentUser.uid
        ]
        
        FirebaseConstants.ChannelRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.MessageRef.child(channel.id).child(messageId).setValue(messageDict)
        
        onComplete()
    }
    
    static func sendMediaMessage(to channel:ChannelItem,params:MessageUploadParams,completion:@escaping () -> Void){
        guard let messageId = FirebaseConstants.MessageRef.childByAutoId().key else { return }
        let timeStamp = Date().timeIntervalSince1970
        
        let channelDict : [String:Any] = [
            .lastMessage : params.text,
            .lastMessageTimeStamp:timeStamp,
            .lastMessageType: params.type.title
        ]
        
        var messageDict : [String:Any] = [
            .text: params.text,
            .type: params.type.title,
            .timeStamp: timeStamp,
            .ownerUid : params.ownerUID
        ]
        
        /// Photo Messages
        messageDict[.thumbnailUrl] = params.thumbnailURL ?? nil
        messageDict[.thumbnailWidth] = params.thumbnailWidth ?? nil
        messageDict[.thumbnailHeight] = params.thumbnailHeight ?? nil
        
        FirebaseConstants.ChannelRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.MessageRef.child(channel.id).child(messageId).setValue(messageDict)
        completion()
    }
    
    static func getMessage(for channel:ChannelItem,completion: @escaping([MessageItem]) -> Void){
        FirebaseConstants.MessageRef.child(channel.id).observe(.value){ snapshot in
            guard let dict = snapshot.value as? [String:Any] else { return }
            var messages:[MessageItem] = []
            dict.forEach { key,value in
                let messageDict = value as? [String:Any] ?? [:]
                let message = MessageItem(id: key, isGroupChat: channel.isGroupChat ,dict: messageDict)
                messages.append(message)
                if messages.count == snapshot.childrenCount{
                    messages.sort { $0.timeStamp < $1.timeStamp }
                    completion(messages)
                }
            }
        }withCancel: { error in
            print("Failed to get messges for \(channel.title)")
        }
    }
    
    
}


struct MessageUploadParams {
    let channel:ChannelItem
    let text:String
    let type:MessageType
    let attachment:MediaAttachment
    var thumbnailURL: String?
    var videoURL: String?
    var sender:UserItem
    var audioURL:String?
    var audioDirection:TimeInterval?
    
    var ownerUID:String{
        return sender.uid
    }
    
    var thumbnailWidth:CGFloat?{
        guard type == .photo || type == .video else { return nil}
        return attachment.thumbnail.size.width
    }
    
    var thumbnailHeight:CGFloat?{
        guard type == .photo || type == .video else { return nil}
        return attachment.thumbnail.size.height
    }
    
}
