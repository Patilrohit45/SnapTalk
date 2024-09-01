//
//  String-Extentions.swift
//  SnapTalk
//
//  Created by Rohit Patil on 31/08/24.
//

import Foundation

extension String {
    var isEmptyOrWithSpace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
