//
//  ChatPartnerPickerScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 30/08/24.
//

import SwiftUI

struct ChatPartnerPickerScreen: View {
    @State private var searchText:String = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChatPartnerPickerViewModel()
    
    var onCreate:(_ newChannel:ChannelItem) -> Void
    
    var body: some View {
        NavigationStack(path: $viewModel.navStack){
            List{
                ForEach(ChatPartnerPickerOption.allCases){ item in
                    HeaderItemView(item: item){
                        guard item == ChatPartnerPickerOption.newGroup else { return }
                        viewModel.navStack.append(.groupPartnerPicker)
                    }
                }
                Section{
                    ForEach(viewModel.users){ user in
                        ChatPartnerRowView(user: user)
                            .onTapGesture {
                                viewModel.createDirectChannel(user,completion: onCreate)
                                
                            }
                    }
                }header: {
                    Text("Contacts on SnapTalk")
                        .textCase(nil)
                        .bold()
                }
                if viewModel.isPaginable{
                    loadMoreUsersView()
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),prompt: "Search name or number")
            .navigationTitle("New Chat")
            .navigationDestination(for: ChannelCretionRoute.self){ route in
                destinationView(for: route)
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.errorState.showError){
                Alert(
                    title: Text("Uh Oh😟"),
                    message: Text(viewModel.errorState.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .toolbar{
                trailingNavItem()
            }
            .onAppear{
                viewModel.deSelecetAllChatPartners()
            }
        }
    }
    
    private func loadMoreUsersView() -> some View{
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}

extension ChatPartnerPickerScreen{
    @ViewBuilder
    private func destinationView(for route:ChannelCretionRoute) -> some View{
        switch route{
        case .groupPartnerPicker:
            GroupPartnerPickerScreen(viewModel: viewModel)
        case .setUpGroupChat:
            NewGroupSetUpScreen(viewModel: viewModel, onCreate: onCreate)
        }
    }
}

extension ChatPartnerPickerScreen{
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent{
        ToolbarItem(placement: .topBarTrailing) {
            cancelButton()
        }
    }
    
    private func cancelButton() -> some View{
        Button{
            dismiss()
        }label: {
            Image(systemName: "xmark")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}

extension ChatPartnerPickerScreen{
    private struct HeaderItemView:View {
        let item:ChatPartnerPickerOption
        let onTapHandler:() -> Void
        var body: some View {
            Button{
                onTapHandler()
            }label: {
                buttonBody()
            }
        }
        private func buttonBody() -> some View{
            HStack{
                Image(systemName: item.imageName)
                    .font(.footnote)
                    .frame(width: 40,height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                Text(item.title)
            }
        }
    }
}

enum ChatPartnerPickerOption: String,CaseIterable,Identifiable{
    case newGroup = "New Group"
    case newAccount = "New Account"
    case newCommunity = "New Community"
    
    var id:String{
        return rawValue
    }
    
    var title:String{
        return rawValue
    }
    
    var imageName:String{
        switch self{
        case .newGroup:
            return "person.2.fill"
        case .newAccount:
            return "person.fill.badge.plus"
        case .newCommunity:
            return "person.3.fill"
        }
    }
}


#Preview {
    ChatPartnerPickerScreen{ channel in
        //
    }
}
