//
//  AvatarView.swift
//  GitHubUsers
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import SwiftUI

struct AvatarView: View {
    let avatarUrl: String
    
    var body: some View {
        if let url = URL(string: avatarUrl) {
            DAsyncImage(url: url)
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                .padding(.all, 4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        } else {
            Color.gray.opacity(0.1)
                .frame(width: 84, height: 84)
                .clipShape(Circle())
        }
    }
}
