//
//  PINSetupView.swift
//  SeriesAppSample
//
//  Created by Adauto Pinheiro on 27/07/25.
//

import SwiftUI

struct PINSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isKeyboardActive: Bool
    @ObservedObject var viewModel: PINSetupViewModel

    var body: some View {
        ZStack {
            Color
                .backgroundPrimary
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text(viewModel.step == .enter ? "Create your PIN" : "Confirm your PIN")
                    .font(.title.bold())
                    .padding(.bottom, 24)
                    .foregroundStyle(.textPrimary)

                pinDots(for: viewModel.currentInput)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.error)
                        .font(.caption.bold())
                        .padding(.top, 12)
                }

                if viewModel.step == .confirm {
                    Button("Reset") {
                        viewModel.reset()
                        isKeyboardActive = true
                    }
                    .font(.subheadline.bold())
                    .foregroundStyle(.action)
                    .padding(.top, 24)
                }

                SecureField("", text: viewModel.bindingForCurrentStep)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 0, height: 0)
                    .focused($isKeyboardActive)
                    .onChange(of: viewModel.currentInput) { _, newValue in
                        if newValue.count == 4 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                viewModel.handleCompletion {
                                    dismiss()
                                }
                            }
                        }
                    }
            }
            .padding()
            .onAppear {
                isKeyboardActive = true
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
