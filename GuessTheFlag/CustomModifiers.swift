//
//  CustomModifiers.swift
//  GuessTheFlag
//
//  Created by Instant System iOS Team on 02/01/2026.
//
import SwiftUI

struct ProminentTitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)
      .foregroundStyle(.blue)
  }
}

struct CustomPolicy: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.custom("Arial", size: 24))
  }
}

extension View {
  func prominentTitle() -> some View {
    self.modifier(ProminentTitleModifier())
  }
  func arialPolicity() -> some View {
    self.modifier(CustomPolicy())
  }
}
