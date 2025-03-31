//
//  OnboardingView.swift
//  Tabata Timer
//
//  Created by Connor Black on 01/03/2025.
//

import SwiftUI
import Common

public struct OnboardingData {
    public let title: String
}

public struct OnboardingView: View {

    private let backgroundColor: Color
    private let foregroundColor: Color
    private let data: [OnboardingData]
    private let onboardingComplete: () -> Void
    private let font: Font
    @State private var currentIndex: Int = 0
    private var progress: Double {
        Double(currentIndex) / Double(data.count)
    }
    var isLastOnboardingScreen: Bool {
        currentIndex == data.count - 1
    }

    public init(
        backgroundColor: Color,
        foregroundColor: Color,
        font: Font = .system(size: 32),
        data: [OnboardingData],
        onboardingComplete: @escaping () -> Void
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.data = data
        self.onboardingComplete = onboardingComplete
        self.font = font
    }

    @State var hapticCounter: Int = 0

    public var body: some View {
        BackgroundView(color: backgroundColor) {
//                PlayerView()
//                    .ignoresSafeArea()
//                    .opacity(viewModel.showBackgroundVideo ? 1.0 : 0.0)
//                    .overlay(Color.black.opacity(0.8))
//                    .animation(.easeInOut, value: viewModel.showBackgroundVideo)
            VStack {
                Text(data[currentIndex].title)
                    .font(font)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.white)
                    .fontWeight(.black)
                    .transition(.blurReplace)
                    .id(currentIndex)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal)

                HStack {
                    Spacer()
                    CircleProgressButton(
                        iconName: "chevron.right",
                        progress: progress,
                        foregroundColor: foregroundColor
                    ) {
                        Task {
                            await nextTapped()
                            hapticCounter += 1
                        }
                    }
                    .sensoryFeedback(
                        isLastOnboardingScreen ? .success : .impact,
                        trigger: hapticCounter
                    )

                }
                .padding(.horizontal)

            }
        }
    }

    func nextTapped() async {
        if currentIndex < data.count - 1 {
            withAnimation {
                currentIndex += 1
            }
        } else {
            onboardingComplete()
        }
    }
}

#Preview {
    OnboardingView(
        backgroundColor: .black,
        foregroundColor: .white,
        data: [],
        onboardingComplete: {}
    )
}
