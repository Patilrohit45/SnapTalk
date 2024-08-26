//
//  AuthScreenModel.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import Foundation
import Combine

final class AuthScreenModel:ObservableObject{
    
    // MARK: Published properties
    @Published var isLoading = false
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    // MARK: Computed properties
    var disableLoginButton : Bool{
        return email.isEmpty || password.isEmpty || isLoading
    }
    
    var disableSignUpButton: Bool{
        return email.isEmpty || password.isEmpty || username.isEmpty
    }
}
