//
//  ShowDetailView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

struct ShowDetailView<ViewModel: ShowDetailViewModelType>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Genres: \(viewModel.data.genresText)")
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)

                if let url = viewModel.data.imageURL {
                    AsyncImageView(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .aspectRatio(2/3, contentMode: .fit)
                            .cornerRadius(10)
                    }
                }

                Text(viewModel.data.scheduleText)
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)

                if let summary = viewModel.data.summary {
                    Text(summary)
                        .font(.body)
                        .foregroundStyle(.textPrimary)
                }

                AsyncView(viewModel.seasonsState) { seasons in
                    SeasonsView(seasons: seasons)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.backgroundPrimary)
        .navigationTitle(viewModel.data.name)
        .task {
            await viewModel.onAppear()
        }
    }
}


#Preview {
    ShowDetailView(viewModel: ShowDetailViewModel(show: ShowDetailData(from: .mock)))
}
