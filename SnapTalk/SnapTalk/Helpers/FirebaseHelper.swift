//
//  FirebaseHelper.swift
//  SnapTalk
//
//  Created by Rohit Patil on 02/09/24.
//

import Foundation
import UIKit
import FirebaseStorage

typealias UploadCompletion = (Result<URL,Error>) -> Void
typealias ProgressHandler = (Double) -> Void

enum UploadError:Error{
    case failedToUploadImage(_ description:String)
    case failedToUploadFile(_ description:String)
}

extension UploadError : LocalizedError{
    var errorDescription: String? {
        switch self{
            
        case .failedToUploadImage(let description):
            return description
         
        case .failedToUploadFile(let description):
            return description
        }
    }
}

struct FirebaseHelper{

    /// This is going to be responsible for uploading image files to our storage bucket
    static func uploadImage(
        _ image:UIImage,
        for type:UploadType,
        completion:@escaping UploadCompletion,
        progressHandler:@escaping ProgressHandler){
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            
            let storageRef = type.filePath
           let uploadTask = storageRef.putData(imageData) { _, error in
                if let error = error{
                    print("Failed to Upload Image to Storage \(error.localizedDescription)")
                    completion(.failure(UploadError.failedToUploadImage(error.localizedDescription)))
                    return
                }
                
                storageRef.downloadURL(completion: completion)
            }
            
            uploadTask.observe(.progress) { snapshot in
                guard let progress = snapshot.progress else { return }
                let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
                progressHandler(percentage)
            }
        }
    
    /// This is going to be responsible for uploading both video and audio files to our storage bucket
    static func uploadFile(
        for type: UploadType,
        fileURL:URL,
        completion: @escaping UploadCompletion,
        progressHandler: @escaping ProgressHandler){
        
            
            let storageRef = type.filePath
           let uploadTask = storageRef.putFile(from: fileURL) { _, error in
                if let error = error{
                    print("Failed to Upload File to Storage \(error.localizedDescription)")
                    completion(.failure(UploadError.failedToUploadFile(error.localizedDescription)))
                    return
                }
                
                storageRef.downloadURL(completion: completion)
            }
            
            uploadTask.observe(.progress) { snapshot in
                guard let progress = snapshot.progress else { return }
                let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
                progressHandler(percentage)
            }
            
    }
}


extension FirebaseHelper{
    enum UploadType{
        case profile
        case photoMessage
        case videoMessage
        case voiceMessage
        
        var filePath:StorageReference{
            let filename = UUID().uuidString
            switch self {
            case .profile:
                return FirebaseConstants.StorageRef.child("profile_image_url").child(filename)
            case .photoMessage:
                return FirebaseConstants.StorageRef.child("photo_messages").child(filename)
            case .videoMessage:
                return FirebaseConstants.StorageRef.child("pvideo_messages").child(filename)
            case .voiceMessage:
                return FirebaseConstants.StorageRef.child("voice_messages").child(filename)
            }
        }
    }
}
