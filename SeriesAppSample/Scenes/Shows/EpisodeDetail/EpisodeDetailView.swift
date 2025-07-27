//
//  EpisodeDetailView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import SwiftUI

struct EpisodeDetailView<ViewModel: EpisodeDetailViewModelType>: View {

    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if let url = viewModel.data.imageURL {
                        AsyncImageView(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            PlaceholderImage(size: .large)
                                .aspectRatio(16/9, contentMode: .fit)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.data.name)
                            .font(.title.bold())
                            .foregroundStyle(.accentPrimary)

                        Text("Season \(viewModel.data.season), Episode \(viewModel.data.number)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.accentSecondary)

                        if let summary = viewModel.data.summary {
                            Text(summary)
                                .font(.body)
                                .foregroundStyle(.textPrimary)
                        } else {
                            Text("No summary available.")
                                .font(.body)
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(viewModel.data.name)
            .navigationBarTitleDisplayMode(.inline)
            .background(.backgroundPrimary)

            CloseButton()
                .padding()
        }
    }
}
