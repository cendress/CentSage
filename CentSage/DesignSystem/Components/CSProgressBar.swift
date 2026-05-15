//
//  CSProgressBar.swift
//  CentSage
//

import SwiftUI

struct CSProgressBar: View {
  var progress: Double
  var tint: Color = CSColor.brandGreen
  var trackColor: Color = CSColor.secondaryBackground
  var height: CGFloat = 10
  
  private var clampedProgress: Double {
    guard progress.isFinite else { return 0 }
    return min(max(progress, 0), 1)
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: height / 2, style: .continuous)
          .fill(trackColor)
        
        RoundedRectangle(cornerRadius: height / 2, style: .continuous)
          .fill(tint)
          .frame(width: geometry.size.width * clampedProgress)
      }
    }
    .frame(height: height)
    .animation(.easeInOut(duration: 0.25), value: clampedProgress)
  }
}
