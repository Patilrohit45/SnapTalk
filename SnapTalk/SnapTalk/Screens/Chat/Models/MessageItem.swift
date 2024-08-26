//
//  MessageItem.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI


struct MessageItem:Identifiable{
    
    let id = UUID().uuidString
    let text:String
    let type:MessageType
    let direction:MessageDirection
    
    static let sentPlaceholder = MessageItem(text: "Hello Rohit", type: .text, direction: .sent)
    static let receivedPlaceholder = MessageItem(text: "Hii Rohit", type: .text, direction: .received)
    
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
        MessageItem(text: "Hii There!", type: .text, direction: .sent),
        MessageItem(text: "Check out this photo", type: .photo, direction: .received),
        MessageItem(text: "Play out this Video", type: .video, direction: .sent),
        MessageItem(text: "", type: .audio, direction: .received)

    ]
}

enum MessageDirection {
    case sent,received
    
    static var random:MessageDirection{
        return [MessageDirection.sent,.received].randomElement() ?? .sent
    }
}

enum MessageType{
    case text,photo,video,audio
}
