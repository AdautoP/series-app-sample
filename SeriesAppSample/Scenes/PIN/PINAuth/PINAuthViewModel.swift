//
//  PINAuthViewModel.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import Foundation
import LocalAuthentication
import SwiftUI

final class PINAuthViewModel: ObservableObject {
    @Published var pin: String = ""
    @Published var errorMessage: String?
    @Published var biometricAvailable: Bool = false

    var onClose: (() -> Void)?

    init(onClose: (() -> Void)? = nil) {
        self.onClose = onClose
        checkBiometricsAvailability()
    }

    private func checkBiometricsAvailability() {
        let context = LAContext()
        var error: NSError?
        biometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    func validatePIN() {
        if PINStorage.validate(pin: pin) {
            onClose?()
        } else {
            errorMessage = "Invalid PIN"
            pin = ""
        }
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access the app") { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.onClose?()
                } else {
                    self?.biometricAvailable = false
                }
            }
        }
    }
}
