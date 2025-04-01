//
//  File.swift
//  Onboarding
//
//  Created by Connor Black on 01/04/2025.
//

import SwiftUI

public extension Image {
    func backgroundImage(opacity: Double = 0.9) -> AnyView {
        AnyView(
            self
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(content: {
                    Color.black.opacity(opacity)
                })
        )
    }
}
