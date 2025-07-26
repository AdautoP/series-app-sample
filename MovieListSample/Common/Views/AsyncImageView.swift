//
//  AsyncImageView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

final class ImageCache {
    static let shared = ImageCache()

    private init() {}

    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insertImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct AsyncImageView<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    @State private var downloadTask: Task<Void, Never>?
    @State private var loadedImage: Image?
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            if let image = loadedImage {
                content(image)
            } else {
                placeholder()
            }

            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.8)
                    .tint(.action)
            }
        }
        .task(id: url) {
            loadImage()
        }
    }

    private func loadImage() {
        // Cancela qualquer download anterior antes de iniciar um novo
        downloadTask?.cancel()

        guard let url else { return }

        if let cached = ImageCache.shared.image(for: url) {
            loadedImage = Image(uiImage: cached)
            return
        }

        isLoading = true
        downloadTask = Task {

            do {
                let config = URLSessionConfiguration.ephemeral
                config.timeoutIntervalForRequest = 10
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                let session = URLSession(configuration: config)

                let (data, _) = try await session.data(from: url)
                if let uiImage = UIImage(data: data) {
                    ImageCache.shared.insertImage(uiImage, for: url)
                    await MainActor.run {
                        loadedImage = Image(uiImage: uiImage)
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run { isLoading = false }
            }
        }
    }

}
