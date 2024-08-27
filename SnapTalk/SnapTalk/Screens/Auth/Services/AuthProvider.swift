//
//  AuthProvider.swift
//  SnapTalk
//
//  Created by Rohit Patil on 27/08/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum AuthState{
    case pending, loggedIn(UserItem), loggedOut
}

protocol AuthProvider{
    
    static var shared:AuthProvider { get }
    var authState: CurrentValueSubject<AuthState,Never> { get }
    func autoLogin() async
    func login(with email:String, and password:String) async throws
    func createAccount(for username:String,with email:String, and password:String) async throws
    func logOut() async throws
    
}

enum AuthError:Error{
    case accountCreationFailed(_ description:String)
    case failedToSaveUserInfo(_ description:String)
}

extension AuthError : LocalizedError{
    var errorDescription: String? {
        switch self{
        case .accountCreationFailed(let description):
            return description
            
        case .failedToSaveUserInfo(let description):
            return description
        }
    }
}

final class AuthManager: AuthProvider {

    private init(){ 
        Task{
            await autoLogin()
        }
    }
    
    static let shared:  AuthProvider = AuthManager()
    
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil{
            authState.send(.loggedOut)
        }else{
                fetchCurrentUserInfo()
        }
    }
    
    func login(with email: String, and password: String) async throws {
        //
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        // Invoke firebase create account method
        //store the new user info in our database
        do{
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid, username: username, email: email)
           try await saveUserInfoDatabase(user: newUser)
            self.authState.send(.loggedIn(newUser))
        }catch{
            print("🔐 failed to Create and Account \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(error.localizedDescription)
        }
    }
    
    func logOut() async throws {
        do{
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("🔐 Successfully logged out !")
        }catch{
            print("🔐 failed to log out current user \(error.localizedDescription)")
        }
    }
    
    
}

extension AuthManager{
    private func saveUserInfoDatabase(user:UserItem) async throws{
        do{
            let userDictionary : [String:Any] = [.uid:user.id,.username:user.username,.email:user.email]
            
            try await  FirebaeConstants.UserRef.child(user.uid).setValue(userDictionary)
        }catch{
            print("🔐 failed to save user info to database \(error.localizedDescription)")
            throw AuthError.failedToSaveUserInfo(error.localizedDescription)
        }
    }
    private func fetchCurrentUserInfo() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaeConstants.UserRef.child(currentUid).observe(.value){ [weak self] snapshot in
            guard let userDict = snapshot.value as? [String:Any] else { return }
            let loggedInUser = UserItem(dictionary: userDict)
            self?.authState.send(.loggedIn(loggedInUser))
            print("🔓 \(loggedInUser.username) is logged in")
        } withCancel: { error in
            print("Failed to get current user Info")
        }
    }
}


