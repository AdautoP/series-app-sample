//
//  PlaceholderImageSize.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import SwiftUI

enum PlaceholderImageSize {
    case small, medium, large

    var iconSize: Font {
        switch self {
        case .small: return .caption
        case .medium: return .title3
        case .large: return .largeTitle
        }
    }
}

struct PlaceholderImage: View {
    let size: PlaceholderImageSize

    var body: some View {
        Rectangle()
            .fill(Color.backgroundSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Image(systemName: "photo")
                    .font(size.iconSize)
                    .foregroundColor(.backgroundTertiary)
            )
            .cornerRadius(4)
    }
}
