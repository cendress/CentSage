//
//  DotsIndicator.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import SwiftUI

struct DotsIndicator: View {
  var numberOfPages: Int
  var currentPage: Int

  var body: some View {
    HStack(spacing: CSSpacing.xs) {
      ForEach(0..<numberOfPages, id: \.self) { index in
        Capsule()
          .fill(index == currentPage ? CSColor.brandGreen : CSColor.border)
          .frame(width: index == currentPage ? 28 : 8, height: 8)
          .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentPage)
      }
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Page \(currentPage + 1) of \(numberOfPages)")
  }
}
