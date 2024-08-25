//
//  MainTabView.swift
//  SnapTalk
//
//  Created by Rohit Patil on 26/08/24.
//

import SwiftUI

struct MainTabView: View {
    
    init(){
        makeTabbarOpaque()
    }
    
    var body: some View {
        TabView{
            UpdatesTabScreen()
                .tabItem {
                    Image(systemName: Tab.updates.icon)
                    Text(Tab.updates.title)
                }
            placeholderItemView("Calls")
                .tabItem {
                Image(systemName: Tab.calls.icon)
                Text(Tab.calls.title)
            }
            placeholderItemView("Communities")
                .tabItem {
                Image(systemName: Tab.communities.icon)
                Text(Tab.communities.title)
            }
            
            placeholderItemView("Chats")
                .tabItem {
                Image(systemName: Tab.chats.icon)
                Text(Tab.chats.title)
            }
            placeholderItemView("Settings")
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
    MainTabView()
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
