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
                }

                Spacer()

                if !show.genres.isEmpty {
                    Text(show.genres.joined(separator: ", "))
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
        .fixedSize()
    }

    private var showImage: some View {
        Group {
            if let urlString = show.image?.medium,
               let url = URL(string: urlString) {
                AsyncImageView(
                    url: url
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    placeholderImage
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
                .clipped()
            } else {
                placeholderImage
            }
        }
        .frame(width: 60, height: 90)
        .cornerRadius(8)
        .clipped()
    }

    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 60, height: 90)
            .overlay(
                Image(systemName: "photo")
                    .font(.caption)
                    .foregroundColor(.gray)
            )
    }
}

#Preview {
    ShowRowView(show: Show(
        id: 1,
        url: "",
        name: "Mock Show",
        type: "Scripted",
        language: "English",
        genres: ["Drama", "Comedy"],
        status: "Running",
        runtime: 30,
        averageRuntime: 30,
        premiered: "2020-01-01",
        ended: nil,
        officialSite: nil,
        schedule: .init(time: "20:00", days: ["Monday"]),
        rating: .init(average: 8.5),
        weight: 90,
        network: .init(id: 1, name: "Mock Network", country: .init(name: "US", code: "US", timezone: "America/New_York"), officialSite: nil),
        webChannel: nil,
        dvdCountry: nil,
        externals: .init(tvrage: nil, thetvdb: nil, imdb: nil),
        image: .init(medium: "", original: ""),
        summary: "A show about mocks",
        updated: 0,
        links: .init(self: .init(href: ""), previousepisode: nil)
    ))
    .background(.backgroundPrimary)
}
