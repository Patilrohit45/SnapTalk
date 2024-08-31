//
//  ChannelTabScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct ChannelTabScreen: View {
    @State private var searchText = ""
    @State private var showChatPartnerView = false
    var body: some View {
        NavigationStack {
            List{
                archivedButton()
                ForEach(0..<5){_ in
                    NavigationLink(destination: ChatRoomScreen()) {
                        ChannelItemView()
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
            .sheet(isPresented: $showChatPartnerView, content: {
                ChatPartnerPickerScreen()
            })
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
            showChatPartnerView = true
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
