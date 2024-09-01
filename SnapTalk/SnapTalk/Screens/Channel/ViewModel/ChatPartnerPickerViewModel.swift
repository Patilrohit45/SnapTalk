//
//  ChatPartnerPickerViewModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 30/08/24.
//

import Foundation
import Firebase
import FirebaseAuth

enum ChannelCretionRoute{
    case groupPartnerPicker
    case setUpGroupChat
}

enum ChannelConstants{
    static let maxGroupParticipants = 12
}

enum ChannelCreationError:Error{
    case noChatPartner
    case failedToCreateUniqueIds
}

@MainActor
final class ChatPartnerPickerViewModel:ObservableObject{
    @Published var navStack = [ChannelCretionRoute]()
    @Published var selectedChatPartners = [UserItem]()
    @Published private(set) var users = [UserItem]()
    @Published var errorState:(showError:Bool,errorMessage:String) = (false,"Uh Oh")
    
    private var lastCursor:String?
    
    var showSelectedUsers:Bool{
        return !selectedChatPartners.isEmpty
    }
    
    var disableNextButton:Bool{
        return selectedChatPartners.isEmpty
    }
    
    var isPaginable:Bool{
        return !users.isEmpty
    }
    
    private var isDirectChannel:Bool{
        return selectedChatPartners.count == 1
    }
    
    init(){
        Task{
            await fetchUsers()
        }
    }
    
    //MARK: Public metods
    func fetchUsers() async{
        do{
           let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            fetchedUsers = fetchedUsers.filter { $0.uid != currentUid}
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
        }catch{
            print("💿 Failed to fetch users in ChatPartnerPicekerModel")
        }
    }
    
    func deSelecetAllChatPartners(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.selectedChatPartners.removeAll()
        }
    }
    
    func handleItemSelection(_ item: UserItem){
        if isUserSelcted(item){
            //deselect
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid}) else { return }
            selectedChatPartners.remove(at: index)
        }else{
            //select
            guard selectedChatPartners.count < ChannelConstants.maxGroupParticipants else{
                let errorMessage = "Sorry, We only allow a maximum of \(ChannelConstants.maxGroupParticipants) participants in a group chat."
                showError(errorMessage)
                return
            }
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelcted(_ user:UserItem) -> Bool{
        let isSelected = selectedChatPartners.contains{ $0.uid == user.uid }
        return isSelected
    }
    

    func createDirectChannel(_ chatPartner:UserItem,completion:@escaping (_ newChannel:ChannelItem) -> Void){
        selectedChatPartners.append(chatPartner)
        Task{
            /// If Existing DM, get the channel
            if let channelId = await verifyIfDirectChannelExists(with: chatPartner.uid){
                let snapshot = try await FirebaseConstants.ChannelRef.child(channelId).getData()
                let channelDict = snapshot.value as! [String:Any]
                var directChannel = ChannelItem(channelDict)
                directChannel.members = selectedChatPartners
                completion(directChannel)
            }else{
                /// create a new DM with the user
                let channelCreation = createChannel(nil)
                    switch channelCreation {
                    case .success(let channel):
                        completion(channel)
                    case .failure(let error):
                        print("Failed to create a Direct Chnnael: \(error.localizedDescription)")
                        showError("Sorry! Something went wrong while we were Trying to Setup Your Chat")
                    }
            }
          
        }
    }
    
    typealias ChannelId = String
    private func verifyIfDirectChannelExists(with chatPartnerId:String) async -> ChannelId?{
        guard let currentUid = Auth.auth().currentUser?.uid,
              let snapShot = try? await FirebaseConstants.UserDirectChannels.child(currentUid).child(chatPartnerId).getData(),
              snapShot.exists()
        else { return nil }
        
        let directMessageDict = snapShot.value as! [String:Bool]
        let channelId = directMessageDict.compactMap { $0.key}.first
        return channelId

    }
    
    private func showError(_ errorMessage:String){
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    
    func createGroupChannel(_ groupName:String?, completion:@escaping (_ newChannel:ChannelItem) -> Void){
        let channelCreation = createChannel(groupName)
            switch channelCreation {
            case .success(let channel):
                completion(channel)
            case .failure(let error):
                print("Failed to create a Group Chnnael: \(error.localizedDescription)")
                showError("Sorry! Something went wrong while we were Trying to Setup Your Group Chat")
            }
    }
    
    private func createChannel(_ channelName:String?) -> Result<ChannelItem,Error>{
        guard !selectedChatPartners.isEmpty else { return  .failure(ChannelCreationError.noChatPartner)}
        
        guard let channelId = FirebaseConstants.ChannelRef.childByAutoId().key,
              let currentUid = Auth.auth().currentUser?.uid,
              let messageId = FirebaseConstants.MessageRef.childByAutoId().key
        else { return .failure(ChannelCreationError.failedToCreateUniqueIds)}
        
        let timeStamp = Date().timeIntervalSince1970
        var membersUid = selectedChatPartners.compactMap{ $0.uid }
        membersUid.append(currentUid)
         
         let newchannelBrodcast = AdminMessageType.channelCreation.rawValue
         
        var channelDict: [String:Any] = [
            .id : channelId,
            .lastMessage : newchannelBrodcast,
            .creationDate : timeStamp,
            .lastMessageTimeStamp : timeStamp,
            .membersUid: membersUid,
            .membersCount : membersUid.count,
            .adminsUids : [currentUid],
            .createdBy : currentUid
        ]
        
        if let channelName = channelName, !channelName.isEmptyOrWithSpace{
            channelDict[.name] = channelName
        }
         
         let messageDict:[String:Any] = [.type:newchannelBrodcast,
                                         .timeStamp:timeStamp,
                                         .ownerUid : currentUid]
        
        FirebaseConstants.ChannelRef.child(channelId).setValue(channelDict)
         FirebaseConstants.MessageRef.child(channelId).child(messageId).setValue(messageDict)
         
         
        membersUid.forEach{ userId in
            /// keeping an index if the channel that a specific user belongs to
            FirebaseConstants.UserChannelRef.child(currentUid).child(channelId).setValue(true)
        }
         /// Makes sure that a direct channel is unique
         if isDirectChannel{
             let chatPartner = selectedChatPartners[0]
             FirebaseConstants.UserDirectChannels.child(currentUid).child(chatPartner.uid).setValue([channelId:true])
             FirebaseConstants.UserDirectChannels.child(chatPartner.uid).child(currentUid).setValue([channelId:true])
         }
         
        var newChannelItem = ChannelItem(channelDict)
         newChannelItem.members = selectedChatPartners
        return .success(newChannelItem)
    }
}
