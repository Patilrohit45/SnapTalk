//
//  RootScreenModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 27/08/24.
//

import Foundation
import Combine

final class RootScreenModel : ObservableObject{
    @Published private(set) var authState = AuthState.pending
    private var cancellables:AnyCancellable?
    init(){
       cancellables = AuthManager.shared.authState.receive(on: DispatchQueue.main)
            .sink { [weak self] latestAuthState in
                self?.authState = latestAuthState
            }
        
//        AuthManager.testAccount.forEach { email in
//            registerTestAccount(with:email)
//        }
    }
    
//    private func registerTestAccount(with email : String){
//        Task{
//            let username = email.replacingOccurrences(of: "@test.com", with: "")
//            try? await AuthManager.shared.createAccount(for: username, with: email, and: "12345678")
//        }
//    }
}
