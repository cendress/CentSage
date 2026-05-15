//
//  CSAmountText.swift
//  CentSage
//

import SwiftUI

struct CSAmountText: View {
  enum Size {
    case large
    case medium
    case small
    
    var font: Font {
      switch self {
      case .large:
        return CSFont.amountLarge
      case .medium:
        return CSFont.amountMedium
      case .small:
        return CSFont.amountSmall
      }
    }
  }
  
  let amount: Double
  var size: Size = .medium
  var color: Color? = nil
  var showsSign: Bool = false
  
  var body: some View {
    Text(formattedAmount)
      .font(size.font)
      .foregroundStyle(color ?? CSColor.primaryText)
      .monospacedDigit()
  }
  
  private var formattedAmount: String {
    let value = CurrencyFormatter.string(from: amount)
    
    if showsSign && amount > 0 {
      return "+\(value)"
    }
    
    return value
  }
}
