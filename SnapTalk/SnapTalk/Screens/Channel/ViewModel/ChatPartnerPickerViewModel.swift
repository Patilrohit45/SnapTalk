//
//  ChatPartnerPickerViewModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 30/08/24.
//

import Foundation


enum ChannelCretionRoute{
    case groupPartnerPicker
    case setUpGroupChat
}

enum ChannelConstants{
    static let maxGroupParticipants = 12
}

final class ChatPartnerPickerViewModel:ObservableObject{
    @Published var navStack = [ChannelCretionRoute]()
    @Published var selectedChatPartners = [UserItem]()
    
    var showSelectedUsers:Bool{
        return !selectedChatPartners.isEmpty
    }
    
    var disableNextButton:Bool{
        return selectedChatPartners.isEmpty
    }
    
    //MARK: Public metods
    func handleItemSelection(_ item: UserItem){
        if isUserSelcted(item){
            //deselect
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid}) else { return }
            selectedChatPartners.remove(at: index)
        }else{
            //select
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelcted(_ user:UserItem) -> Bool{
        let isSelected = selectedChatPartners.contains{ $0.uid == user.uid }
        return isSelected
    }
}
