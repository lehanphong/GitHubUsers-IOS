//
//  Item.swift
//  GitHubUsers
//
//  Created by Nguyen Tien Duc on 28/3/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
