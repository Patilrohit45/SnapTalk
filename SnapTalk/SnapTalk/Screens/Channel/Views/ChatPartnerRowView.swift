//
//  ChatPartnerRowView.swift
//  SnapTalk
//
//  Created by Rohit Patil on 30/08/24.
//

import SwiftUI

struct ChatPartnerRowView<Content:View>: View {
    private let user:UserItem
    private let trailingItems : Content
    
    init(user: UserItem, @ViewBuilder trailingItems:() -> Content = { EmptyView() }) {
        self.user = user
        self.trailingItems = trailingItems()
    }
    
    var body: some View {
        HStack{
            //user.profileImageUrl
            CircularProfileImageView(nil,size: .xSmall)
                
            VStack(alignment:.leading){
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            trailingItems
        }
    }
}

#Preview {
    ChatPartnerRowView(user: .placeholder){
        Image(systemName: "xmark")
    }
}
