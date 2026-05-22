//
//  Double+Currency.swift
//  CentSage
//

import Foundation

extension Double {
  var currencyString: String {
    CurrencyFormatter.string(from: self)
  }
  
  var absoluteCurrencyString: String {
    CurrencyFormatter.string(from: abs(self))
  }
}
