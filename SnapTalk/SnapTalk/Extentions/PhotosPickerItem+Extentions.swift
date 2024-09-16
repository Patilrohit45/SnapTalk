//
//  PhotosPickerItem+Extentions.swift
//  SnapTalk
//
//  Created by Rohit Patil on 01/09/24.
//

import Foundation
import PhotosUI
import SwiftUI

extension PhotosPickerItem{
    var isVideo:Bool{
        let videoUTTypes: [UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTTypes.contains(where: supportedContentTypes.contains)
    }
}
