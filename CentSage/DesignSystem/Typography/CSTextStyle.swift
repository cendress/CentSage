//
//  CSTextStyle.swift
//  CentSage
//

import SwiftUI

enum CSTextStyle {
  case largeTitle
  case title1
  case title2
  case title3
  case headline
  case body
  case bodyMedium
  case callout
  case subheadline
  case footnote
  case caption
  case amountLarge
  case amountMedium
  case amountSmall
  
  var font: Font {
    switch self {
    case .largeTitle:
      return CSFont.largeTitle
    case .title1:
      return CSFont.title1
    case .title2:
      return CSFont.title2
    case .title3:
      return CSFont.title3
    case .headline:
      return CSFont.headline
    case .body:
      return CSFont.body
    case .bodyMedium:
      return CSFont.bodyMedium
    case .callout:
      return CSFont.callout
    case .subheadline:
      return CSFont.subheadline
    case .footnote:
      return CSFont.footnote
    case .caption:
      return CSFont.caption
    case .amountLarge:
      return CSFont.amountLarge
    case .amountMedium:
      return CSFont.amountMedium
    case .amountSmall:
      return CSFont.amountSmall
    }
  }
}
