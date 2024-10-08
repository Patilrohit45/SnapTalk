//
//  MainTabView.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct MainTabView: View {
    
    private let currentUser:UserItem
    
    init(_ currentUser:UserItem){
        self.currentUser = currentUser
        makeTabbarOpaque()
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        TabView{
            UpdatesTabScreen()
                .tabItem {
                    Image(systemName: Tab.updates.icon)
                    Text(Tab.updates.title)
                }
            CallsTabScreen()
                .tabItem {
                Image(systemName: Tab.calls.icon)
                Text(Tab.calls.title)
            }
            CommunityTabScreen()
                .tabItem {
                Image(systemName: Tab.communities.icon)
                Text(Tab.communities.title)
            }
            
            ChannelTabScreen(currentUser)
                .tabItem {
                Image(systemName: Tab.chats.icon)
                Text(Tab.chats.title)
            }
            SettingsTabScreen()
                .tabItem {
                Image(systemName: Tab.settings.icon)
                Text(Tab.settings.title)
            }
        }
    }
    
    private func makeTabbarOpaque(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView(.placeholder)
}

extension MainTabView{
    
    private func placeholderItemView(_ title:String) -> some View{
        Text(title)
            .font(.largeTitle)
    }
    
    private enum Tab:String{
        case updates, calls,communities,chats,settings
        
        fileprivate var title:String{
            return rawValue.capitalized
        }
        
        fileprivate var icon:String{
            switch self{
            case .updates:
                return "circle.dashed.inset.filled"
            
            case .calls:
                return "phone"
                
            case .communities:
                return "person.3"
            
            case .chats:
                return "message"
        
            case .settings:
                return "gear"
            }
        }
    }
}
