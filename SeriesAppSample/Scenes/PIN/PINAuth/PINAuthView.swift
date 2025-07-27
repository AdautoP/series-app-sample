//
//  PINAuthView.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//


import SwiftUI
import LocalAuthentication

struct PINAuthView: View {
    @State private var pin: String = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss
    var onClose: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Text("Enter your PIN")
                .font(.title.bold())

            SecureField("PIN", text: $pin)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Unlock") {
                if PINStorage.validate(pin: pin) {
                    dismiss()
                    onClose?()
                } else {
                    errorMessage = "Invalid PIN"
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Use Face ID / Touch ID") {
                authenticateWithBiometrics()
            }
            .font(.footnote)
        }
        .padding()
        .onAppear {
            authenticateWithBiometrics()
        }
    }

    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access the app") { success, _ in
                DispatchQueue.main.async {
                    if success {
                        dismiss()
                        onClose?()
                    }
                }
            }
        }
    }
}
