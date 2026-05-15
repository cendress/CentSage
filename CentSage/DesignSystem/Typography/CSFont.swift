//
//  CSFont.swift
//  CentSage
//

import SwiftUI

enum CSFont {
  static let largeTitle: Font = .system(size: 34, weight: .bold, design: .rounded)
  static let title1: Font = .system(size: 28, weight: .bold, design: .rounded)
  static let title2: Font = .system(size: 22, weight: .semibold, design: .rounded)
  static let title3: Font = .system(size: 20, weight: .semibold, design: .rounded)
  
  static let headline: Font = .system(size: 17, weight: .semibold, design: .default)
  static let body: Font = .system(size: 17, weight: .regular, design: .default)
  static let bodyMedium: Font = .system(size: 17, weight: .medium, design: .default)
  static let callout: Font = .system(size: 16, weight: .regular, design: .default)
  static let subheadline: Font = .system(size: 15, weight: .regular, design: .default)
  static let footnote: Font = .system(size: 13, weight: .regular, design: .default)
  static let caption: Font = .system(size: 12, weight: .medium, design: .default)
  
  static let amountLarge: Font = .system(size: 32, weight: .bold, design: .rounded)
  static let amountMedium: Font = .system(size: 22, weight: .semibold, design: .rounded)
  static let amountSmall: Font = .system(size: 17, weight: .semibold, design: .rounded)
}
