//
//  ChatRoomScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    var body: some View {
        MessageListView()
        .toolbar(.hidden,for: .tabBar)
        .toolbar{
            leadingNavItem()
            trailingNavItem()
        }
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}

extension ChatRoomScreen{
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                Circle()
                    .frame(width: 35,height: 35)
                
                Text("Rohit45")
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent{
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button{
                
            }label: {
                Image(systemName: "video")
            }
            
            Button{
                
            }label: {
                Image(systemName: "phone")
            }
        }
    }
}

#Preview {
    NavigationStack{
        ChatRoomScreen()
    }
}
