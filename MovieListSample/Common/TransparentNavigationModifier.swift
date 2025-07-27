//
//  TransparentNavigationModifier.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

struct TransparentNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
               applyTransparentNavigationBarAppearance()
            }
    }
}

extension View {
    func applyTransparentNavigation() -> some View {
        self.modifier(TransparentNavigationModifier())
    }
}

func applyTransparentNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
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
}

