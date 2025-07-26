//
//  ContentView.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 25/07/25.
//

import SwiftUI

struct ShowsListView<ViewModel: ShowsListViewModelType>: View {

    @FocusState var searchFieldFocused: Bool
    @ObservedObject var viewModel: ViewModel
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        VStack {
            mainList
                .overlay {
                    if !viewModel.searchQuery.isEmpty {
                        searchResultsList
                    }
                }
        }
        .background(.backgroundPrimary)
        .searchable(text: $viewModel.searchQuery, prompt: Text("Search shows…"))
        .navigationTitle("All shows")
        .onAppear {
            Task { await viewModel.onAppear() }

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "backgroundPrimary") ?? .systemBackground
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "textPrimary") ?? UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textPrimary") ?? UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance

            if let textColor = UIColor(named: "textPrimary") {
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
                    .foregroundColor: textColor
                ]
            }
        }
    }

    private var mainList: some View {
        AsyncView(viewModel.state) { shows in
            VStack {
                List(shows) { show in
                    ShowRowView(show: show)
                        .onAppear {
                            if show == shows.last {
                                if !viewModel.isLoadingBottom {
                                    viewModel.reachedBottom()
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            viewModel.tapShow(show)
                        }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

                if viewModel.isLoadingBottom {
                    HStack {
                        Spacer()

                        ProgressView()
                            .padding(.vertical)
                            .tint(.action)

                        Spacer()
                    }
                    .fixedSize()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchResultsList: some View {
        AsyncView(viewModel.searchState, showLoadingOverlay: true) { shows in
            // TODO: Implement empty state if shows.isEmpty
            List(shows) { show in
                ShowRowView(show: show)
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        viewModel.tapShow(show)
                    }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .zIndex(1)
        }
        .background(.backgroundPrimary)
    }
}

class MockVM: ShowsListViewModelType {

    
    var searchQuery: String = ""

    var isLoadingBottom: Bool = false

    func reachedBottom() {}

    @Published var state: LoadableState<[Show]> = .success([.mock])
    @Published var searchState: LoadableState<[Show]> = .success([.mock])
    func onAppear() async {}
    func tapShow(_ show: Show) {}
}

#Preview {
    ShowsListView(viewModel: MockVM())
}



