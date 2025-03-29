//
//  LoadingView.swift
//  GitHubUsers
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }
}
