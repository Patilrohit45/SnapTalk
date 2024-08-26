import SwiftUI

struct SignUpScreen: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject  var authScreenModel : AuthScreenModel
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                
                AuthTextfield(type: .email, text: $authScreenModel.email)
                
                let userNameType = AuthTextfield.InputType.custom("Username", "at")
                
                AuthTextfield(type: userNameType, text: $authScreenModel.username)
                
                AuthTextfield(type: .password, text: $authScreenModel.password)
                
                AuthButton(title: "Create an Acccount") {
                    // Sign up action
                }
                .disabled(authScreenModel.disableSignUpButton)
                
                Spacer()
                
                backButton()
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                LinearGradient(colors: [.green.opacity(0.8), .teal], startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
        }
    }
    
    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                (
                    Text("Already created an account?")
                    +
                    Text(" Log In").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignUpScreen(authScreenModel: AuthScreenModel())
}
