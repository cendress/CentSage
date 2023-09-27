//
//  SavingProgressView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/27/23.
//

import SwiftUI

struct SavingProgressView: View {
  var value: Double
  var total: Double
  
  var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width * CGFloat(value / total)
      
      ZStack(alignment: .leading) {
        Rectangle()
          .frame(width: geometry.size.width, height: geometry.size.height)
          .opacity(0.3)
          .foregroundColor(Color(UIColor.systemGray4))
        
        Rectangle()
          .frame(width: width, height: geometry.size.height)
          .foregroundColor(Color("CentSageGreen"))
      }
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color(UIColor.systemGray5), lineWidth: 1)
      )
    }
  }
}
