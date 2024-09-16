//
//  ChatRoomViewModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 31/08/24.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI

@MainActor
final class ChatRoomViewModel : ObservableObject{
    @Published var textMessage = ""
    @Published var messages = [MessageItem]()
    @Published var showPhotoPicker = false
    @Published var photoPickerItems:[PhotosPickerItem] = []
    @Published var mediaAttachments:[MediaAttachment] = []
    @Published var videoPlayerState:(show:Bool,player:AVPlayer?) = (false,nil)
    @Published var isRecordingVoiceMessage = false
    @Published var elapsedVoiceMessageTime:TimeInterval = 0
    @Published var scrollBottomRequest: (scroll: Bool,isAnimate:Bool) = (false,false)
    
    private(set) var channel:ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    private var currentUser:UserItem?
    private let voiceRecorderService = VoiceRecorderService()
    
    var showPhotoPickerPreview:Bool{
        return !mediaAttachments.isEmpty || !photoPickerItems.isEmpty
    }
    
    var disableSendButton:Bool{
        return mediaAttachments.isEmpty && textMessage.isEmptyOrWithSpace
    }
    
    init(_ channel: ChannelItem){
        self.channel = channel
        listenToAuthState()
        setUpVoiceRecorderListeners()
        onPhotoPickerSelection()
        
    }
    
    deinit{
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            guard let self = self else { return }
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
                if self.channel.allMembersFetched{
                    self.getMessage()
                }else{
                    self.getAllChannelMembers()
                }
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    private func setUpVoiceRecorderListeners() {
        voiceRecorderService.$isRecording
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                self?.isRecordingVoiceMessage = isRecording
            }
            .store(in: &subscriptions)
        
        voiceRecorderService.$elapsedTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] elapsedTime in
                self?.elapsedVoiceMessageTime = elapsedTime
            }
            .store(in: &subscriptions)
    }
    
    
    func sendMessage(){
        guard let currentUser else { return }
        if mediaAttachments.isEmpty{
            MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) { [weak self] in
                self?.textMessage = ""
            }
        }else{
            sendMultipleMediaMessages(textMessage,attachment: mediaAttachments)
            clearTextInputArea()
            
        }
    }
    
    private func clearTextInputArea(){
        mediaAttachments.removeAll()
        photoPickerItems.removeAll()
        textMessage = ""
        UIApplication.dismissKeyboard()
    }
    
    private func sendMultipleMediaMessages(_ text:String, attachment:[MediaAttachment]){
        mediaAttachments.forEach{ attachment in
            switch attachment.type{
                case .photo:
                sendPhotoMessage(text: text, attachment)
            case .video:
               break
            case .audio:
                break
            }
        }
    }
    
    private func sendPhotoMessage(text:String,_ attchment:MediaAttachment){
        /// Upload the image to storage
        uploadImageToStorage(attchment) {[weak self] imageUrl in
            ///  Store metadata  to our database
            guard let self = self, let currentUser else { return }
            
            let uploadParams = MessageUploadParams(
                channel: channel,
                text: text,
                type: .photo,
                attachment: attchment,
                thumbnailURL: imageUrl.absoluteString, 
                sender: currentUser
            )
            MessageService.sendMediaMessage(to: channel, params: uploadParams) { [weak self] in
                /// TODO: Scroll to bottom upon image upload success
                self?.scrollToBottom(isAnimated: true)
            }
        }
       
    }
    
    private func scrollToBottom(isAnimated:Bool){
        scrollBottomRequest.scroll = true
        scrollBottomRequest.isAnimate = isAnimated
    }
    
    private func uploadImageToStorage(_ attachment:MediaAttachment, completion: @escaping(_ imageUrl:URL) ->Void) {
        FirebaseHelper.uploadImage(attachment.thumbnail, for: .photoMessage){ result in
            switch result{
            case .success(let imageURL):
                completion(imageURL)
            case .failure(let error):
                print("Failed to upload Image to Storage \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD IMAGE PROGRESS: \(progress)")
        }
    }
    
    
    func getMessage(){
        MessageService.getMessage(for: channel){[weak self] messages in
            self?.messages = messages
        }
    }
    
    func getAllChannelMembers(){
        guard let currentUser = currentUser else { return }
        let membersAlreadyFetched = channel.members.compactMap{ $0.uid }
        var memberUIDFetch = channel.membersUids.filter { !membersAlreadyFetched.contains($0) }
        memberUIDFetch = memberUIDFetch.filter{ $0 != currentUser.uid }
        
        UserService.getUsers(with: memberUIDFetch){[weak self] userNode in
            guard let self = self else { return }
            self.channel.members.append(contentsOf: userNode.users)
            self.getMessage()
        }
    }
    
    func handleTextInputArea(_ action: TextInputArea.UserAction){
        switch action{
        case .presentPhotoPicker:
            showPhotoPicker = true
            
        case .sendMessage:
            sendMessage()
            
        case .recordAudio:
            toggleAudioRecorder()
        }
    }
    
    private func toggleAudioRecorder(){
        if voiceRecorderService.isRecording {
            // stop recording
            voiceRecorderService.stopRecording { [weak self] audioURL, audioDuration in
                self?.createAudioAttachment(from:audioURL,audioDuration)
            }
        }else{
            //start recording
            voiceRecorderService.startRecording()
        }
    }
    
    private func createAudioAttachment(from audioURL:URL?,_ audioDuration:TimeInterval){
        guard let audioURL = audioURL else { return }
        let id = UUID().uuidString
        let audioAttachment = MediaAttachment(id: id, type: .audio(audioURL,audioDuration))
        mediaAttachments.insert(audioAttachment, at: 0)
    }
    
    private func onPhotoPickerSelection(){
        $photoPickerItems
            .sink { [weak self] photoItems in
                guard let self = self else { return }
                self.mediaAttachments.removeAll()
                Task{
                    await self.parsePhotoPickerItems(photoItems)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func parsePhotoPickerItems(_ photoPickerItems:[PhotosPickerItem]) async{
        for photoItem in photoPickerItems{
            if photoItem.isVideo{
                if let movie = try? await photoItem.loadTransferable(type: VideoPickerTransferable.self), let thumbnail = try? await movie.url.generateVideoThumbnail(), let itemIdentifier = photoItem.itemIdentifier{
                    let videoAttachment = MediaAttachment(id: itemIdentifier, type: .video(thumbnail, movie.url))
                    self.mediaAttachments.insert(videoAttachment, at: 0)
                }
            }else{
                guard
                    let data = try? await photoItem.loadTransferable(type: Data.self),
                    let thumbnail = UIImage(data: data),
                    let itemIdentifier = photoItem.itemIdentifier
                else {return}
                let photoAttachment = MediaAttachment(id: itemIdentifier, type: .photo(thumbnail))
                self.mediaAttachments.insert(photoAttachment,at:0)
            }
        }
    }
    
    func dismissMediaPlayer(){
        videoPlayerState.player?.replaceCurrentItem(with: nil)
        videoPlayerState.player = nil
        videoPlayerState.show = false
    }
    
    func showMediaPlayer(_ fileURL:URL){
        videoPlayerState.show = true
        videoPlayerState.player = AVPlayer(url: fileURL)
    }
    
    func handleMediaAttachmentPreview(_ action:MediaAttachmentPreview.UserAction){
        
        switch action{
        case .play(let attachment):
            guard let fileURL = attachment.fileURL else { return }
            showMediaPlayer(fileURL)
        case .removeItem(let attachment):
            remove(attachment)
            guard let fileURL = attachment.fileURL else { return }
            if attachment.type == .audio(.stubUrl, .stubTimeInterval){
                voiceRecorderService.deleteRecording(at:fileURL)
            }
        }
    }
    
    private func remove(_ item:MediaAttachment){
        guard let attachmentIndex = mediaAttachments.firstIndex(where: { $0.id == item.id }) else { return }
        mediaAttachments.remove(at: attachmentIndex)
        
        guard let photoIndex = photoPickerItems.firstIndex(where: { $0.itemIdentifier == item.id }) else { return }
        photoPickerItems.remove(at: photoIndex)
    }
}
