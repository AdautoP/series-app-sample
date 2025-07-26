//
//  DSColors.swift
//  MovieListSample
//
//  Created by Adauto Pinheiro on 26/07/25.
//


import SwiftUI

enum DSColor: String {
    case backgroundPrimary
    case backgroundSecondary
    case textPrimary
    case textSecondary
    case accentPrimary
    case accentSecondary
    case surfaceCard
    case surfaceElevated
    case divider

    var color: Color {
        Color(rawValue)
    }
}

