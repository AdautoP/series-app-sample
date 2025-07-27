//
//  ShowRowView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

struct ShowRowView: View {
    let show: Show

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            showImage
                .shadow(radius: 4.0)

            VStack(alignment: .leading, spacing: 0) {
                Text(show.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(.textPrimary)

                if let rating = show.rating.average {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Image(systemName: "star.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.action)

                        Text((String(format: "%.1f", rating)))
                            .font(.caption.bold())
                            .foregroundColor(.action)
                    }
                    .padding(.top, 4)
                }

                Spacer()

                if !show.genres.isEmpty {
                    Text(show.genres.joined(separator: ", "))
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.accentSecondary)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal)
        }
    }

    private var showImage: some View {
        Group {
            if let url = show.image?.medium {
                AsyncImageView(
                    url: url
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    PlaceholderImage(size: .small)
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
                .clipped()
            } else {
                PlaceholderImage(size: .small)
            }
        }
        .frame(width: 60, height: 90)
        .cornerRadius(8)
        .clipped()
    }
}

#Preview {
    ShowRowView(show: .mock)
    .background(.backgroundPrimary)
}
