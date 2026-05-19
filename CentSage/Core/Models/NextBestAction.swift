//
//  NextBestAction.swift
//  CentSage
//

import Foundation

struct NextBestAction {
  enum Priority {
    case warning
    case budget
    case savings
    case empty
    case positive
  }

  let title: String
  let message: String
  let systemImage: String
  let priority: Priority
}
