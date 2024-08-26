//
//  AuthTextfield.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct AuthTextfield: View {
    let type:InputType
    @Binding var text:String
    var body: some View {
        HStack{
            Image(systemName: type.imageName)
                .fontWeight(.semibold)
                .frame(width: 30)
            
            switch type {
            case .password:
                SecureField(type.placeholder,text: $text)
             default:
                TextField(type.placeholder, text: $text)
                    .keyboardType(type.keyboardType)
            }
            
            
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.white.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal,32)
    }
}

extension AuthTextfield{
    enum InputType{
        case email
        case password
        case custom(_ placeholder:String,_ iconName:String)
        
        var placeholder:String{
            switch self{
            case .email:
                return "Email"
            case .password:
                return "Password"
            case .custom(let placeholder,_):
                return placeholder
            }
        }
        
        var imageName:String{
            switch self{
            case .email:
                return "envelope"
            case .password:
                return "lock"
            case .custom(_, let iconName):
                return iconName
            }
        }
        
        var keyboardType:UIKeyboardType{
            switch self{
            case .email:
                return .emailAddress
                
            default:
                return .default
            }
        }
    }
}

#Preview {
    ZStack {
        Color.teal
        VStack {
            AuthTextfield(type: .email, text: .constant(""))
            AuthTextfield(type: .password, text: .constant(""))
            AuthTextfield(type: .custom("Birthday", "birthday.cake"), text: .constant(""))
        }
    }
}
