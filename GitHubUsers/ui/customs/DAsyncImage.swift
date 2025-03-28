//
//  DAsyncImage.swift
//  GitHubUsers
//
//  Created by Nguyen Tien Duc on 28/3/25.
//

import Foundation
import SwiftUI

// Custom RemoteImage view for loading images
struct DAsyncImage: View {
    @State private var image: UIImage? = nil
    let url: URL
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray.opacity(0.1) // Placeholder
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }
        task.resume()
    }
}
