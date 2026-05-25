//
//  CSColor.swift
//  CentSage
//

import SwiftUI
import UIKit

enum CSColor {
  static let brandGreen = Color(hex: "58B248")
  static let brandGreenLight = Color(hex: "EAF7E7")
  
  static let background = Color.dynamic(light: "F8FAF7", dark: "0F1510")
  static let secondaryBackground = Color.dynamic(light: "F1F5EF", dark: "171F18")
  static let cardBackground = Color.dynamic(light: "FFFFFF", dark: "1D261E")
  
  static let primaryText = Color.dynamic(light: "172117", dark: "F3F7F2")
  static let secondaryText = Color.dynamic(light: "5E6B5D", dark: "B8C5B6")
  static let tertiaryText = Color.dynamic(light: "8A9588", dark: "7F8C7D")
  
  static let border = Color.dynamic(light: "DDE6DA", dark: "2D3A2E")
  static let divider = Color.dynamic(light: "E7EEE5", dark: "263226")
  
  static let positive = Color.dynamic(light: "58B248", dark: "6FD35E")
  static let negative = Color.dynamic(light: "D94D4D", dark: "FF6B6B")
  static let warning = Color.dynamic(light: "E6A23C", dark: "F5B84B")
  static let info = Color.dynamic(light: "3E8ED0", dark: "64B5F6")
  
  static let income = Color.dynamic(light: "58B248", dark: "6FD35E")
  static let expense = Color.dynamic(light: "D94D4D", dark: "FF6B6B")
  static let budget = Color.dynamic(light: "A66DD4", dark: "C58AF9")
}
