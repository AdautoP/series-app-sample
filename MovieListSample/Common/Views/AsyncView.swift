//
//  AsyncView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//

import SwiftUI

enum LoadableState<Success: Equatable>: Equatable {
    case idle
    case loading
    case success(Success)
    case failure(Error)

    static func == (lhs: LoadableState<Success>, rhs: LoadableState<Success>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.success(let l), .success(let r)):
            return l == r
        case (.failure(let l), .failure(let r)):
            return l.localizedDescription == r.localizedDescription
        default:
            return false
        }
    }
}


struct AsyncView<Success: Equatable, Content: View, Loading: View, ErrorContent: View>: View {
    let state: LoadableState<Success>
    let showLoadingOverlay: Bool
    let content: (Success) -> Content
    let loadingView: () -> Loading
    let errorView: (Error) -> ErrorContent

    @State private var lastSuccessValue: Success?

    init(
        _ state: LoadableState<Success>,
        showLoadingOverlay: Bool = false,
        @ViewBuilder content: @escaping (Success) -> Content,
        @ViewBuilder loadingView: @escaping () -> Loading,
        @ViewBuilder errorView: @escaping (Error) -> ErrorContent
    ) {
        self.state = state
        self.showLoadingOverlay = showLoadingOverlay
        self.content = content
        self.loadingView = loadingView
        self.errorView = errorView
    }

    var body: some View {
        Group {
            switch state {
            case .idle, .loading:
                if showLoadingOverlay, let last = lastSuccessValue {
                    ZStack {
                        content(last)
                        loadingOverlay()
                    }
                } else {
                    loadingView()
                }

            case .failure(let error):
                errorView(error)

            case .success(let value):
                content(value)
            }
        }
        .onChange(of: state) { oldValue, newValue in
            if newValue != oldValue {
                trackSuccess(newValue)
            }
        }
    }

    private func trackSuccess(_ newValue: LoadableState<Success>) {
        if case .success(let value) = newValue {
            lastSuccessValue = value
        }
    }

    private func loadingOverlay() -> some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()
            loadingView()
        }
    }
}

extension AsyncView where Loading == DefaultLoadingView, ErrorContent == DefaultErrorView {
    init(
        _ state: LoadableState<Success>,
        showLoadingOverlay: Bool = false,
        @ViewBuilder content: @escaping (Success) -> Content
    ) {
        self.init(
            state,
            showLoadingOverlay: showLoadingOverlay,
            content: content,
            loadingView: { DefaultLoadingView() },
            errorView: { error in DefaultErrorView(error: error) }
        )
    }
}

struct DefaultLoadingView: View {
    var body: some View {
        ProgressView()
    }
}

struct DefaultErrorView: View {
    let error: Error

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

