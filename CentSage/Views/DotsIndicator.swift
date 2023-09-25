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
    HStack {
      ForEach(0..<numberOfPages, id: \.self) { index in
        Circle()
          .frame(width: 10, height: 10)
          .foregroundColor(index == currentPage ? .blue : .gray)
          .overlay(Circle().stroke(Color.black, lineWidth: 1))
          .padding(.horizontal, 4)
      }
    }
  }
}
