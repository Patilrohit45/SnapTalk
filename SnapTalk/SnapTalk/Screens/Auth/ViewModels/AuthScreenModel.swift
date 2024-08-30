//
//  AuthScreenModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import Foundation


@MainActor
final class AuthScreenModel:ObservableObject{
    
    // MARK: Published properties
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var errorState: (showError:Bool, errorMessage:String) = (false,"Uh Oh")
    
    // MARK: Computed properties
    var disableLoginButton : Bool{
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool{
        return email.isEmpty || password.isEmpty || username.isEmpty
    }
    
    func handleSignIn() async{
        isLoading = true
        do{
            try await AuthManager.shared.login(with: email, and: password)
        }catch{
            errorState.errorMessage = "Failed to login \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
    
    func handleSignUp() async{
        isLoading = true
        do{
            try await AuthManager.shared.createAccount(for: username, with: email, and: password)
        }catch{
            errorState.errorMessage = "Failed to create account \(error.localizedDescription)"
            errorState.showError = true
            isLoading = false
        }
    }
}
