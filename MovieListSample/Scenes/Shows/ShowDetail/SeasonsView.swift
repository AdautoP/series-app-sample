//
//  SeasonsView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

struct Season: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let episodes: [Episode]
}

import SwiftUI

struct SeasonsView: View {
    let seasons: [Season]
    @State private var selectedSeason: Season?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(seasons, id: \.id) { season in
                        Text(season.name)
                            .fontWeight(season == selectedSeason ? .bold : .regular)
                            .foregroundColor(season == selectedSeason ? .accentColor : .textDisabled)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedSeason = season
                                }
                            }
                    }
                }
                .padding(.top)
            }

            if let selected = selectedSeason {
                let columns: [GridItem] = [
                    GridItem(.fixed(140), spacing: 16)
                ]

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: columns, spacing: 16) {
                        ForEach(selected.episodes) { episode in
                            EpisodeCardView(episode: episode)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .onAppear {
            if selectedSeason == nil {
                selectedSeason = seasons.first
            }
        }
    }
}


