//
//  BackButton.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
                .font(.title2.weight(.medium))
                .padding(10)
                .background(.regularMaterial)
                .clipShape(Circle())
        }
        .foregroundColor(.primary)
        .shadow(radius: 4)
    }
}
