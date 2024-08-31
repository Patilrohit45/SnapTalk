//
//  SelectedChatPartnerView.swift
//  SnapTalk
//
//  Created by Rohit Patil on 30/08/24.
//

import SwiftUI

struct SelectedChatPartnerView: View {
    let users:[UserItem]
    let onTapHandler: (_ user:UserItem) -> Void
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(users){ item in
                    ChatPartnerView(item)
                }
            }
        }
    }
    
    private func ChatPartnerView(_ user:UserItem) -> some View{
        VStack{
            Circle()
                .fill(.gray)
                .frame(width: 60,height: 60)
                .overlay(alignment:.topTrailing){
                    cancelButton(user)
                }
            Text(user.username)
        }
    }
    
    private func cancelButton(_ user:UserItem) -> some View{
        Button{
            onTapHandler(user)
        }label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(5)
                .background(Color(.systemGray2))
                .clipShape(Circle())
        }
    }
}

#Preview {
    SelectedChatPartnerView(users: UserItem.placeholders){ user in
            //
    }
}
