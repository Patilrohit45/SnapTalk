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
    let direction:MessageDirection
    
    static let sentPlaceholder = MessageItem(text: "Hello Rohit", direction: .sent)
    static let receivedPlaceholder = MessageItem(text: "Hii Rohit", direction: .received)
    
    var alignment:Alignment{
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment:HorizontalAlignment{
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor : Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
}

enum MessageDirection {
    case sent,received
    
    static var random:MessageDirection{
        return [MessageDirection.sent,.received].randomElement() ?? .sent
    }
}
