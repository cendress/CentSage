//
//  Color+Hex.swift
//  CentSage
//

import SwiftUI
import UIKit

extension Color {
  init(hex: String) {
    self.init(UIColor(hex: hex))
  }
  
  static func dynamic(light: String, dark: String) -> Color {
    Color(UIColor { traitCollection in
      traitCollection.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
    })
  }
}

extension UIColor {
  convenience init(hex: String) {
    var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if cleanedHex.hasPrefix("#") {
      cleanedHex.removeFirst()
    }
    
    var value: UInt64 = 0
    Scanner(string: cleanedHex).scanHexInt64(&value)
    
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    switch cleanedHex.count {
    case 8:
      red = CGFloat((value & 0xFF000000) >> 24) / 255
      green = CGFloat((value & 0x00FF0000) >> 16) / 255
      blue = CGFloat((value & 0x0000FF00) >> 8) / 255
      alpha = CGFloat(value & 0x000000FF) / 255
    case 6:
      red = CGFloat((value & 0xFF0000) >> 16) / 255
      green = CGFloat((value & 0x00FF00) >> 8) / 255
      blue = CGFloat(value & 0x0000FF) / 255
      alpha = 1
    default:
      red = 0
      green = 0
      blue = 0
      alpha = 1
    }
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
