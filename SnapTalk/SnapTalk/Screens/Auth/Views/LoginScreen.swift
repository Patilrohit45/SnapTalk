//
//  LoginScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var authScreenModel = AuthScreenModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                
                AuthTextfield(type: .email, text: $authScreenModel.email)
                AuthTextfield(type: .password, text: $authScreenModel.password)
                
                foregotPasswordButton()
                
                AuthButton(title: "Login"){
                    
                }
                .disabled(authScreenModel.disableLoginButton)
                
                Spacer()
                
                signUpButton()
                    .padding(.bottom,30)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.teal.gradient)
            .ignoresSafeArea()
            .alert(isPresented: $authScreenModel.errorState.showError){
                Alert(
                    title: Text(authScreenModel.errorState.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
    
    private func foregotPasswordButton() -> some View{
        Button{
            
        }label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment:.trailing)
                .padding(.trailing,32)
                .bold()
                .padding(.vertical)
        }
    }
    
    private func signUpButton() -> some View{
        NavigationLink{
            SignUpScreen(authScreenModel: authScreenModel)
        } label: {
            HStack{
                Image(systemName: "sparkles")
                
                (
                Text("Don't have an account ?")
                +
                Text("Create one").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoginScreen()
}
