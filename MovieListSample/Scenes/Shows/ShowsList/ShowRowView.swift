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
        HStack(alignment: .top, spacing: 16) {
            showImage

            VStack(alignment: .leading, spacing: 6) {
                Text(show.name)
                    .font(.headline)

                if let rating = show.rating.average {
                    Text("⭐️ \(String(format: "%.1f", rating))")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }

                if !show.genres.isEmpty {
                    Text(show.genres.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var showImage: some View {
        Group {
            if let urlString = show.image?.medium,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        placeholderImage
                    }
                }
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
}
