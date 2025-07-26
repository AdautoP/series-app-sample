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
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if let url = viewModel.data.imageURL {
                        ZStack(alignment: .bottomLeading) {
                            AsyncImageView(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                                    .aspectRatio(2/3, contentMode: .fit)
                            }

                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, Color.clear]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .frame(height: 180)
                            .allowsHitTesting(false) // para não interceptar toques

                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.data.name)
                                    .font(.title.bold())
                                    .foregroundColor(.accentPrimary)

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
                        SeasonsView(seasons: seasons)
                    }
                    .padding(.horizontal)
                }
            }

            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2.weight(.medium))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .foregroundColor(.primary)
            .padding(.top, 50) // pode ajustar conforme status bar
            .padding(.leading, 16)
        }
        .frame(maxWidth: .infinity)
        .background(.backgroundPrimary)
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    ShowDetailView(viewModel: ShowDetailViewModel(show: ShowDetailData(from: .mock)))
}
