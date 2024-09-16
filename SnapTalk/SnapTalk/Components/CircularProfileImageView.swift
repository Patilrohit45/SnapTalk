//
//  CircularProfileImageView.swift
//  SnapTalk
//
//  Created by Rohit Patil on 01/09/24.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    let profileImageUrl:String?
    let size:Size
    let fallBackImage:FallBackImage
    
    init(_ profileImageUrl: String? = nil, size: Size) {
        self.profileImageUrl = profileImageUrl
        self.size = size
        self.fallBackImage = .directChatIcon
    }
    
    var body: some View {
        if let profileImageUrl{
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .placeholder { ProgressView() }
                .scaledToFill()
                .frame(width: size.dimention,height: size.dimention)
                .clipShape(Circle())
        }else{
            placeholderImageUrl()
        }
    }
    private func placeholderImageUrl() -> some View{
        Image(systemName: fallBackImage.rawValue)
            .resizable()
            .scaledToFit()
            .imageScale(.large)
            .foregroundStyle(Color.placeholder)
            .frame(width: size.dimention,height: size.dimention)
            .background(Color.white)
            .clipShape(Circle())
    }
}

extension CircularProfileImageView{
    enum Size {
        case mini,xSmall,small,medium,large,xLarge
        case custom(CGFloat)
        
        var dimention:CGFloat{
            switch self {
            case .mini:
                return 30
            case .xSmall:
                return 40
            case .small:
                return 50
            case .medium:
                return 60
            case .large:
                return 80
            case .xLarge:
                return 120
            case .custom(let dimen):
                return dimen
            }
        }
    }
    
    enum FallBackImage:String{
        case directChatIcon = "person.circle.fill"
        case groupChateIcon = "person.2.circle.fill"
        
    init(for membersCount:Int){
        switch membersCount{
            case 2:
                self = .directChatIcon
            default:
                self = .groupChateIcon
            }
        }
    }
}

extension CircularProfileImageView{
    init(_ channel:ChannelItem,size:Size){
        self.profileImageUrl = channel.coverImageUrl
        self.size = size
        self.fallBackImage = FallBackImage(for: channel.membersCount)
    }
}

#Preview {
    CircularProfileImageView(size: .large)
}
