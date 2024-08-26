//
//  CommunityTabScreen.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct CommunityTabScreen: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment:.leading,spacing: 10){
                    Image(.communities)
                    
                    Group{
                        Text("Stay connected with a communitiy")
                            .font(.title2)
                        Text("Communities bring members together in topic-based groups.Any community you're added to will appear here.")
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal,10)
                    
                    Button("See example communities >"){ }
                        .frame(maxWidth: .infinity,alignment: .center)
                    
                    createNewCommunityButton()
                }
                .padding()
                .navigationTitle("Communities")
            }
        }
    }
    
    private func createNewCommunityButton() -> some View{
        Button{
            
        }label: {
            Label("New Community",systemImage: "plus")
                .bold()
                .frame(maxWidth: .infinity,alignment: .center)
                .foregroundStyle(.white)
                .padding(10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                .padding()
        }
    }
}

#Preview {
    CommunityTabScreen()
}
