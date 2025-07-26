//
//  EpisodeCardView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

struct EpisodeCardView: View {
    let episode: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let url = episode.image?.medium {
                AsyncImageView(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 140, height: 80)
                .clipped()
                .cornerRadius(8)
            } else {
                Color.gray.opacity(0.3)
            }

            Text(episode.name)
                .font(.caption)
                .lineLimit(1)
                .foregroundStyle(.textPrimary)

            Text("Ep \(episode.number)")
                .font(.caption2)
                .foregroundColor(.textPrimary)
        }
        .frame(width: 140)
    }
}
