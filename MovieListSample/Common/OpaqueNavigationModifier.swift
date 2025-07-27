//
//  OpaqueNavigationModifier.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

struct OpaqueNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                applyOpaqueNavigationBarAppearance()
            }
    }
}

extension View {
    func applyOpaqueNavigation() -> some View {
        self.modifier(OpaqueNavigationModifier())
    }
}

func applyOpaqueNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "backgroundPrimary") ?? .systemBackground
    appearance.largeTitleTextAttributes = [
        .foregroundColor: UIColor(named: "textPrimary") ?? .white
    ]
    appearance.titleTextAttributes = [
        .foregroundColor: UIColor(named: "textPrimary") ?? .white
    ]

    let navBar = UINavigationBar.appearance()
    navBar.standardAppearance = appearance
    navBar.scrollEdgeAppearance = appearance
    navBar.compactAppearance = appearance

    if let textColor = UIColor(named: "textPrimary") {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .defaultTextAttributes = [.foregroundColor: textColor]
    }
}
