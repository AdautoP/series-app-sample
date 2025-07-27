//
//  PINSetupViewModel.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import Foundation
import SwiftUI

final class PINSetupViewModel: ObservableObject {
    enum Step {
        case enter
        case confirm
    }

    @Published var step: Step = .enter
    @Published var enteredPIN: String = ""
    @Published var confirmPIN: String = ""
    @Published var errorMessage: String?

    private let storage: PINStorageType
    var onClose: (() -> Void)?

    init(storage: PINStorageType = PINStorage.shared,
         onClose: (() -> Void)? = nil) {
        self.storage = storage
        self.onClose = onClose
    }

    var currentInput: String {
        step == .enter ? enteredPIN : confirmPIN
    }

    var bindingForCurrentStep: Binding<String> {
        Binding(
            get: { self.currentInput },
            set: { [weak self] newValue in
                guard let self = self else { return }
                let trimmed = String(newValue.prefix(4))
                if self.step == .enter {
                    self.enteredPIN = trimmed
                } else {
                    self.confirmPIN = trimmed
                }
            }
        )
    }

    func handleCompletion(onSuccess: () -> Void) {
        switch step {
        case .enter:
            errorMessage = nil
            step = .confirm
        case .confirm:
            if confirmPIN == enteredPIN {
                storage.save(pin: confirmPIN)
                onClose?()
                onSuccess()
            } else {
                errorMessage = "PINs do not match"
                confirmPIN = ""
            }
        }
    }

    func reset() {
        enteredPIN = ""
        confirmPIN = ""
        errorMessage = nil
        step = .enter
    }
}
