//
//  ChatRoomScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    let channel : ChannelItem
    @StateObject private var viewModel : ChatRoomViewModel
    
    init(channel:ChannelItem){
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    
    var body: some View {
        MessageListView(viewModel)
        .toolbar(.hidden,for: .tabBar)
        .toolbar{
            leadingNavItem()
            trailingNavItem()
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            TextInputArea(textMessage: $viewModel.textMessage){
                viewModel.sendMessage()
            }
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
                
                Text(channel.title)
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
        ChatRoomScreen(channel: .placeholder)    }
}
