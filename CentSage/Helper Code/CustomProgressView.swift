//
//  CustomProgressView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/27/23.
//

import Foundation
import SwiftUI

struct CustomProgressView: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(Color("CentSageGreen").opacity(0.5))
        Rectangle()
          .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
          .foregroundColor(Color("CentSageGreen"))
      }
    }
  }
}
