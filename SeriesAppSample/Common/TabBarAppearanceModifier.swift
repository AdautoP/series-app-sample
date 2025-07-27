//
//  TabBarAppearanceModifier.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import SwiftUI

struct TabBarAppearanceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                applyTabBarAppearance()
            }
    }
}

extension View {
    func applyTabBarAppearance() -> some View {
        self.modifier(TabBarAppearanceModifier())
    }
}

func applyTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowImage = UIImage()
    appearance.shadowColor = .clear
    appearance.backgroundColor = UIColor(named: "backgroundPrimary") ?? .systemBackground

    let normalFont = UIFont.systemFont(ofSize: 10)
    let selectedFont = UIFont.systemFont(ofSize: 10, weight: .semibold)

    appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "textSecondary") ?? .secondaryLabel
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
        .foregroundColor: UIColor(named: "textSecondary") ?? .secondaryLabel,
        .font: normalFont
    ]

    appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "action") ?? .label
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
        .foregroundColor: UIColor(named: "action") ?? .label,
        .font: selectedFont
    ]

    let tabBar = UITabBar.appearance()
    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
        tabBar.scrollEdgeAppearance = appearance
    }
}


