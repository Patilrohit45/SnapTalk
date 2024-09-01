//
//  ChannelTabScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct ChannelTabScreen: View {
    @State private var searchText = ""
   
    @StateObject private var viewModel = ChannelTabViewModel()
    var body: some View {
        NavigationStack {
            List{
                archivedButton()
                ForEach(viewModel.channels){channel in
                    NavigationLink(destination: ChatRoomScreen(channel: channel)) {
                        ChannelItemView(channel:channel)
                    }
                }
                inboxFooterView()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .toolbar{
                leadingNavItems()
                trailingNavItems()
            }
            .sheet(isPresented: $viewModel.showChatPartnerView){
                ChatPartnerPickerScreen(onCreate: viewModel.onNewChannelCreation)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if let newChannel = viewModel.newChannel{
                    ChatRoomScreen(channel: newChannel)
                }
            }
        }
    }
    
}

extension ChannelTabScreen{
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent{
        ToolbarItem(placement: .topBarLeading) {
            Menu{
                Button{
                    
                }label: {
                    Label("Select Chats",systemImage: "checkmark.circle")
                }
            }label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent{
        ToolbarItemGroup(placement: .topBarTrailing) {
            aiButton()
            cameraButton()
            newChatButton()
        }
    }
    private func aiButton() -> some View{
        Button{
            
        }label: {
            Image(.circle)
        }
    }
    private func newChatButton() -> some View{
        Button{
            viewModel.showChatPartnerView = true
        }label: {
            Image(.plus)
        }
    }
    private func cameraButton() -> some View{
        Button{
            
        }label: {
            Image(systemName: "camera")
        }
    }
    private func archivedButton() -> some View{
        Button{
            
        }label: {
            Label("Archived",systemImage:"archivebox.fill")
                .bold()
                .padding()
                .foregroundStyle(.gray)
        }
    }
    private func inboxFooterView() -> some View{
        HStack{
            Image(systemName: "lock.fill")
            
            (
                Text("Your personal message are ")
                +
                Text("end-to-end encrypted")
                    .foregroundColor(.blue)
            )
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal)
    }
    
    
}

#Preview {
    ChannelTabScreen()
}
