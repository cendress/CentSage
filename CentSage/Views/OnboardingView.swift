//
//  OnboardingView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

struct OnboardingView: View {
  var loginAction: () -> Void
  
  var body: some View {
    Text("Onboarding/Login screen")
    Button("Login") {
      loginAction()
    }
  }
}

#Preview {
  OnboardingView {
    print("Login action performed.")
  }
}
