//
//  ChannelTabViewModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 31/08/24.
//

import Foundation
import Firebase
import FirebaseAuth

enum ChannelTabRoutes:Hashable{
    case chatRoom(_ channel:ChannelItem)
}
final class ChannelTabViewModel : ObservableObject{
    @Published var navigateToChatRoom = false
    @Published var newChannel:ChannelItem?
    @Published var showChatPartnerView = false
    @Published var channels = [ChannelItem]()
    @Published var navRoutes = [ChannelTabRoutes]()
    typealias ChannelId = String
    @Published var channelDictionary: [ChannelId: ChannelItem] = [:]

    private let currentUser:UserItem

    init(_ currentUser:UserItem){
        self.currentUser = currentUser
        fetchCurrentUsersChannels()
    }
    
    func onNewChannelCreation(_ channel:ChannelItem){
        showChatPartnerView = false
        newChannel = channel
        navigateToChatRoom = true
    }
    
    private func fetchCurrentUsersChannels(){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserChannelRef.child(currentUid).observe(.value){ [weak self] snapshot in
            guard let dict = snapshot.value as? [String:Any] else { return }
            dict.forEach { key,value in
                let channelId = key
                self?.getChannel(with: channelId)
            }
        }withCancel: { error in
            print("Failed to get current user's channelIds: \(error.localizedDescription)")
        }
    }
    
    private func getChannel(with channelId:String){
        FirebaseConstants.ChannelRef.child(channelId).observe(.value){[weak self] snapshot in
            guard let dict = snapshot.value as? [String:Any],let self = self else { return }
            var channel = ChannelItem(dict)
            self.getChannelMembers(channel){ members in
                channel.members = members
                    channel.members.append(self.currentUser)

                self.channelDictionary[channelId] = channel
                self.reloadData()
//                self?.channels.append(channel)
            }
        }withCancel: { error in
            print("Failed to get channel for id \(channelId): \(error.localizedDescription)")
        }
    }
    
    private func getChannelMembers(_ channel:ChannelItem, completion:@escaping (_ members:[UserItem]) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let channelMembersUids = Array(channel.membersUids.filter {$0 != currentUid }.prefix(2))
        UserService.getUsers(with: channelMembersUids) {userNode in
            completion(userNode.users)
        }
    }
    
    private func reloadData(){
        self.channels = Array(channelDictionary.values)
        self.channels.sort { $0.lastMessageTimeStamp > $1.lastMessageTimeStamp }
    }
}
