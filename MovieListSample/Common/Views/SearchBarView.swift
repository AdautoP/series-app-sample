//
//  SearchBarView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    var onCancel: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Search shows…")
                        .foregroundStyle(.textSecondary)
                        .padding(10)
                }

                TextField("", text: $text)
                    .padding(10)
                    .focused(isFocused)
                    .foregroundStyle(.textPrimary)
            }
            .background(.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                        .transition(.opacity)
                    }
                }
            )

            Button("Cancel") {
                text = ""
                isFocused.wrappedValue = false
                onCancel?()
            }
            .foregroundStyle(.action)
            .frame(maxWidth: isFocused.wrappedValue ? 64 : 0, maxHeight: 32)
            .animation(.easeInOut, value: isFocused.wrappedValue)
            .padding(.leading, isFocused.wrappedValue ? 8 : 0)
        }
        .animation(.easeInOut, value: isFocused.wrappedValue)
    }
}
