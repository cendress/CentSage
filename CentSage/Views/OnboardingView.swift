//
//  OnboardingView.swift
//  CentSage
//
//  Created by Christopher Endress on 9/22/23.
//

import SwiftUI

struct OnboardingView: View {
  var onCompletion: () -> Void
  
  @State private var selectedPage = 0
  let onboardingScreens = [
    OnboardingScreen(title: "Welcome to CentSage", description: "Wisdom in every cent.", image: "apple.logo"),
    OnboardingScreen(title: "Track Expenses", description: "Keep track of your spending easily.", image: "dollarsign.circle.fill"),
    OnboardingScreen(title: "Set Budgets", description: "Set budgets to avoid overspending.", image: "chart.bar.fill"),
    OnboardingScreen(title: "Achieve Goals", description: "Save money for your goals.", image: "star.fill")
  ]
  
  var body: some View {
    VStack {
      HStack {
        Button(action: {
          if selectedPage == onboardingScreens.count - 1 {
            onCompletion()
          } else {
            withAnimation {
              selectedPage += 1
            }
          }
        }) {
          Text(selectedPage == onboardingScreens.count - 1 ? "Get Started" : "Next")
        }
        Spacer()
        Button(action: onCompletion) {
          Text("Skip")
        }
      }
      .padding()
      
      TabView(selection: $selectedPage) {
        ForEach(0..<onboardingScreens.count, id: \.self) { index in
          let screen = onboardingScreens[index]
          VStack {
            Image(systemName: screen.image)
              .resizable()
              .scaledToFit()
              .frame(width: 200, height: 200)
            Text(screen.title)
              .font(.largeTitle)
              .bold()
            Text(screen.description)
              .multilineTextAlignment(.center)
              .padding()
          }
          .tag(index)
        }
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
      
      PageControl(numberOfPages: onboardingScreens.count, currentPage: $selectedPage)
    }
    .padding()
  }
}

#Preview {
  OnboardingView {
    print("Login action performed.")
  }
}
