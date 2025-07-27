//
//  PINCoordinator.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import SwiftUI

enum PINRoute: Hashable, Identifiable {
    var id: Int {
        switch self {
        case .setup: return 1
        case .auth: return 2
        }
    }

    case setup
    case auth
}

protocol PINRouterType: ObservableObject, Identifiable {
    var id: UUID { get }
    var path: NavigationPath { get set }
    var sheet: PINRoute? { get set }
    var fullScreen: PINRoute? { get set }

    func build(_ onClose: (() -> Void)?) -> any View
}

class PINRouter: PINRouterType, ObservableObject {
    var id: UUID = .init()

    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: PINRoute?
    @Published var fullScreen: PINRoute?

    @ViewBuilder
    func build(_ onClose: (() -> Void)?) -> any View {
        if PINStorage.hasPin {
            PINAuthView(viewModel: PINAuthViewModel(onClose: onClose))
        } else {
            PINSetupView(viewModel: PINSetupViewModel(onClose: onClose))
        }
    }
}

struct PINCoordinatorView<Router: PINRouterType>: View {
    @ObservedObject var router: Router
    var onClose: (() -> Void)?

    var body: some View {
        router.build(onClose).erased
    }
}

// MARK: MOCK

enum PINStorage {
    static var hasPin: Bool {
        UserDefaults.standard.string(forKey: "user_pin") != nil
    }

    static func savePin(_ pin: String) {
        UserDefaults.standard.set(pin, forKey: "user_pin")
    }

    static func validate(pin: String) -> Bool {
        return pin == UserDefaults.standard.string(forKey: "user_pin")
    }
}
