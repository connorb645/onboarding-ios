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
    public let subtitle: String?
    public let backgroundContent: AnyView?
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder backgroundContent: @escaping () -> AnyView? = { nil }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.backgroundContent = backgroundContent()
    }
}

public struct OnboardingView<Background: View>: View {

    private let backgroundColor: Color
    private let foregroundColor: Color
    private let data: [OnboardingData]
    private let onboardingComplete: () -> Void
    private let primaryFont: Font
    private let secondaryFont: Font
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
        primaryFont: Font = .system(size: 32),
        secondaryFont: Font = .system(size: 18),
        data: [OnboardingData],
        onboardingComplete: @escaping () -> Void
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.data = data
        self.onboardingComplete = onboardingComplete
        self.primaryFont = primaryFont
        self.secondaryFont = secondaryFont
    }

    @State var hapticCounter: Int = 0

    public var body: some View {
        BackgroundView(color: backgroundColor) {
            if let backgroundView = data[currentIndex].backgroundContent {
                backgroundView
                    .ignoresSafeArea()
            }
//                PlayerView()
//                    .ignoresSafeArea()
//                    .opacity(viewModel.showBackgroundVideo ? 1.0 : 0.0)
//                    .overlay(Color.black.opacity(0.8))
//                    .animation(.easeInOut, value: viewModel.showBackgroundVideo)
            VStack {
                VStack(spacing: 32) {
                    Text(data[currentIndex].title)
                        .font(primaryFont)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(foregroundColor)
                        .fontWeight(.black)
                        .transition(.blurReplace)
                        .id(currentIndex)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    if let subtitle = data[currentIndex].subtitle {
                        Text(subtitle)
                            .font(secondaryFont)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(foregroundColor.opacity(0.8))
                            .fontWeight(.light)
                            .transition(.blurReplace)
                            .id(currentIndex)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }

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
    OnboardingView<Text>(
        backgroundColor: .black,
        foregroundColor: .white,
        data: [.init(
            title: "Test title",
            subtitle: "Test Subtitle",
            backgroundContent: {
                AnyView(Color.orange)
            }
        )],
        onboardingComplete: {}
    )
}
