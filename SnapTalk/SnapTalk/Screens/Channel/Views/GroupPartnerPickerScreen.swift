//
//  AddGroupChatPartnersScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 30/08/24.
//

import SwiftUI

struct GroupPartnerPickerScreen: View {
    @State private var searchText:String = ""
    @ObservedObject var viewModel : ChatPartnerPickerViewModel
    
    var body: some View {
        List{
            if viewModel.showSelectedUsers{
                SelectedChatPartnerView(users: viewModel.selectedChatPartners){ user in
                    viewModel.handleItemSelection(user)
                }
            }
            
            Section{
                ForEach(UserItem.placeholders){ item in
                    
                    Button{
                        viewModel.handleItemSelection(item)
                    }label: {
                        chatPartnerRowView(item)
                    }
                }
            }
        }
        .animation(.easeInOut,value: viewModel.showSelectedUsers)
        .searchable(text: $searchText,
                     placement: .navigationBarDrawer(displayMode: .always),prompt: "Search name or number")
        .toolbar{
            titleView()
            trailingNavItem()
        }
    }
    
    private func chatPartnerRowView(_ user: UserItem) -> some View{
        ChatPartnerRowView(user: user){
            let isSelected = viewModel.isUserSelcted(user)
            let imageName = isSelected ? "checkmark.circle.fill" : "circle"
            let foregroundStyle = isSelected ? Color.blue : Color(.systemGray4)
            Spacer()
            Image(systemName: imageName)
                .foregroundStyle(foregroundStyle)
                .imageScale(.large)
        }
    }
}

extension GroupPartnerPickerScreen{
    @ToolbarContentBuilder
    private func titleView() ->  some ToolbarContent{
        ToolbarItem(placement: .principal) {
            VStack{
                Text("Add Participants")
                    .bold()
                
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maxGroupParticipants
                
                Text("\(count)/\(maxCount)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    @ToolbarContentBuilder
    private func trailingNavItem() ->  some ToolbarContent{
        ToolbarItem(placement:.topBarTrailing){
            Button("Next"){
                viewModel.navStack.append(.setUpGroupChat)
            }.bold()
                .disabled(viewModel.disableNextButton)
        }
    }
}

#Preview {
    NavigationStack {
        GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
    }
}
