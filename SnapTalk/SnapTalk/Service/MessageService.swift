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
    
    static func getMessage(for channel:ChannelItem,completion: @escaping([MessageItem]) -> Void){
        FirebaseConstants.MessageRef.child(channel.id).observe(.value){ snapshot in
            guard let dict = snapshot.value as? [String:Any] else { return }
            var messages:[MessageItem] = []
            dict.forEach { key,value in
                let messageDict = value as? [String:Any] ?? [:]
                let message = MessageItem(id: key, dict: messageDict)
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
