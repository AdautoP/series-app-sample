//
//  PINAuthView.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import SwiftUI

struct PINAuthView: View {
    @FocusState private var isKeyboardActive: Bool
    @ObservedObject var viewModel: PINAuthViewModel

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Enter your PIN")
                    .font(.title.bold())
                    .padding(.bottom, 24)
                    .foregroundStyle(.textPrimary)

                pinDots(for: viewModel.pin)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.error)
                        .font(.caption.bold())
                        .padding(.top, 12)
                }

                SecureField("", text: $viewModel.pin)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 0, height: 0)
                    .focused($isKeyboardActive)
                    .onChange(of: viewModel.pin) { _, newValue in
                        if newValue.count == 4 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.validatePIN()
                            }
                        }
                    }

                if viewModel.biometricAvailable {
                    Button("Use Face ID / Touch ID") {
                        viewModel.authenticateWithBiometrics()
                    }
                    .font(.subheadline.bold())
                    .padding(.top, 24)
                    .foregroundStyle(.action)
                }
            }
            .padding()
            .onAppear {
                isKeyboardActive = true
                viewModel.authenticateWithBiometrics()
            }
        }
    }

    @ViewBuilder
    private func pinDots(for value: String) -> some View {
        HStack(spacing: 32) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index < value.count ? Color.action : Color.textPrimary)
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        isKeyboardActive = true
                    }
                    .animation(.easeOut(duration: 0.2), value: index < value.count)
            }
        }
    }
}

