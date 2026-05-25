//
//  OnboardingScreen.swift
//  CentSage
//
//  Created by Christopher Endress on 9/25/23.
//

import Foundation

struct OnboardingScreen {
  let title: String
  let description: String
  let visual: OnboardingVisual
}

enum OnboardingVisual: Equatable {
  case monthlySummary
  case quickSpending
  case budgetAwareness
}
