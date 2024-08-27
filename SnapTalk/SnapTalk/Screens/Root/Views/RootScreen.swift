//
//  RootScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 27/08/24.
//

import SwiftUI

struct RootScreen: View {
    @StateObject private var viewModel = RootScreenModel()
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
            
        case .loggedIn(let loggedInUser):
            MainTabView()
        
        case .loggedOut:
            LoginScreen()
        }
    }
}

#Preview {
    RootScreen()
}
