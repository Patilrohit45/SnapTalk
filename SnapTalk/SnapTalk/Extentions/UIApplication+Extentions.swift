//
//  UIApplication+Extentions.swift
//  SnapTalk
//
//  Created by Rohit Patil on 04/09/24.
//

import Foundation
import UIKit

extension UIApplication{
    static func dismissKeyboard(){
        UIApplication
            .shared
            .sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
