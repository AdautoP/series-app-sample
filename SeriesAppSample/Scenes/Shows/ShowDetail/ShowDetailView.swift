//
//  ShowDetailView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

struct ShowDetailView<ViewModel: ShowDetailViewModelType>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if let url = viewModel.data.imageURL {
                    ZStack(alignment: .bottomLeading) {
                        AsyncImageView(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            PlaceholderImage(size: .large)
                        }
                        .aspectRatio(2/3, contentMode: .fit)

                        LinearGradient(
                            gradient: Gradient(colors: [Color.black, Color.clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 180)
                        .allowsHitTesting(false) // para não interceptar toques

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(alignment: .center) {
                                Text(viewModel.data.name)
                                    .font(.title.bold())
                                    .foregroundColor(.accentPrimary)

                                Spacer()

                                Button {
                                    viewModel.toggleFavorite()
                                } label: {
                                    Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.action)
                                }
                            }

                            Text(viewModel.data.genresText)
                                .font(.subheadline.bold())
                                .foregroundColor(.accentSecondary)

                            Text(viewModel.data.scheduleText)
                                .font(.caption)
                                .foregroundColor(.textPrimary)
                        }
                        .padding()
                    }
                }

                Text("Sinopsis")
                    .font(.title.bold())
                    .foregroundStyle(.textPrimary)
                    .padding(.horizontal)

                if let summary = viewModel.data.summary {
                    Text(summary)
                        .font(.body)
                        .foregroundStyle(.textPrimary)
                        .padding(.horizontal)
                }

                Text("Episodes")
                    .font(.title.bold())
                    .foregroundStyle(.textPrimary)
                    .padding(.horizontal)

                AsyncView(viewModel.seasonsState) { seasons in
                    SeasonsView(seasons: seasons) { episode in
                        viewModel.tapEpisode(episode)
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.backgroundPrimary)
        .task {
            await viewModel.onAppear()
        }
    }
}

private class MockShowDetailViewModel: ShowDetailViewModelType {
    var isFavorite: Bool = false
    
    func toggleFavorite() {}
    
    var data: ShowDetailData = .init(from: .mock)

    var seasonsState: LoadableState<[Season]> = .loading

    func onAppear() async {}
    
    func tapEpisode(_ episode: Episode) {}
}

#Preview {
    ShowDetailView(viewModel: MockShowDetailViewModel())
}
