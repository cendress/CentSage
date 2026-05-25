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

  private let onboardingScreens = [
    OnboardingScreen(
      title: "See Your Month",
      description: "See income, spending, and what is left at a glance.",
      visual: .monthlySummary
    ),
    OnboardingScreen(
      title: "Log Spending Fast",
      description: "Add everyday spending in seconds without a long form.",
      visual: .quickSpending
    ),
    OnboardingScreen(
      title: "Stay on Budget",
      description: "See what is spent, what remains, and when a category needs attention.",
      visual: .budgetAwareness
    )
  ]

  private var isLastPage: Bool {
    selectedPage == onboardingScreens.count - 1
  }

  var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $selectedPage) {
        ForEach(onboardingScreens.indices, id: \.self) { index in
          OnboardingPageView(screen: onboardingScreens[index])
            .tag(index)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))

      bottomActions
    }
    .csScreenBackground()
  }

  private var bottomActions: some View {
    VStack(spacing: CSSpacing.sm) {
      DotsIndicator(numberOfPages: onboardingScreens.count, currentPage: selectedPage)
        .padding(.bottom, CSSpacing.xs)

      CSButton(
        title: isLastPage ? "Get Started" : "Next",
        systemImage: isLastPage ? "checkmark" : "arrow.right",
        action: primaryAction
      )

      Button("Skip", action: onCompletion)
        .font(CSFont.callout)
        .foregroundStyle(CSColor.secondaryText)
        .opacity(isLastPage ? 0 : 1)
        .accessibilityHidden(isLastPage)
    }
    .padding(.horizontal, CSSpacing.md)
    .padding(.top, CSSpacing.sm)
    .padding(.bottom, CSSpacing.lg)
    .background(CSColor.background)
  }

  private func primaryAction() {
    if isLastPage {
      onCompletion()
    } else {
      withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
        selectedPage += 1
      }
    }
  }
}

private struct OnboardingPageView: View {
  let screen: OnboardingScreen

  var body: some View {
    VStack(spacing: CSSpacing.lg) {
      Spacer(minLength: CSSpacing.lg)
        
        if screen.visual == .monthlySummary {
            HStack(spacing: CSSpacing.xs) {
                Text("Welcome to")
                Text("CentSage")
                    .foregroundStyle(CSColor.brandGreen)
            }
            .font(CSFont.largeTitle)
            .foregroundStyle(CSColor.primaryText)
            .multilineTextAlignment(.center)
        }

      OnboardingPreview(visual: screen.visual)
        .padding(.horizontal, CSSpacing.md)

      VStack(spacing: CSSpacing.sm) {
          Text(screen.title)
            .font(CSFont.largeTitle)
            .foregroundStyle(CSColor.primaryText)
            .multilineTextAlignment(.center)

        Text(screen.description)
          .font(CSFont.body)
          .foregroundStyle(CSColor.secondaryText)
          .multilineTextAlignment(.center)
          .lineSpacing(3)
          .padding(.horizontal, CSSpacing.md)
      }

      Spacer(minLength: CSSpacing.lg)
    }
    .padding(.horizontal, CSSpacing.md)
  }
}

private struct OnboardingPreview: View {
  let visual: OnboardingVisual

  var body: some View {
    VStack(spacing: CSSpacing.md) {
      switch visual {
      case .monthlySummary:
        MonthlyPreview()
      case .quickSpending:
        QuickSpendingPreview()
      case .budgetAwareness:
        BudgetAwarenessPreview()
      }
    }
    .padding(CSSpacing.lg)
    .frame(maxWidth: .infinity)
    .frame(height: 280)
    .background(
      RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous)
        .fill(CSColor.cardBackground)
    )
    .overlay {
      RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous)
        .stroke(CSColor.border, lineWidth: 1)
    }
    .csCardShadow()
  }
}

private struct MonthlyPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: CSSpacing.md) {
      HStack {
        VStack(alignment: .leading, spacing: CSSpacing.xxs) {
          Text("May 2026")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.secondaryText)

          Text("Leftover")
            .font(CSFont.headline)
            .foregroundStyle(CSColor.primaryText)
        }

        Spacer()

        Image(systemName: "leaf.fill")
          .font(.headline)
          .foregroundStyle(CSColor.brandGreen)
          .frame(width: 34, height: 34)
          .background(CSColor.brandGreen.opacity(0.14))
          .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))
      }

      CSAmountText(amount: 842, size: .large, color: CSColor.income)

      VStack(spacing: CSSpacing.sm) {
        previewRow(title: "Income", amount: 3200, color: CSColor.income)
        previewRow(title: "Spending", amount: 2358, color: CSColor.expense)
      }
    }
  }

  private func previewRow(title: String, amount: Double, color: Color) -> some View {
    HStack {
      Circle()
        .fill(color)
        .frame(width: 9, height: 9)

      Text(title)
        .font(CSFont.subheadline)
        .foregroundStyle(CSColor.secondaryText)

      Spacer()

      CSAmountText(amount: amount, size: .small, color: CSColor.primaryText)
    }
  }
}

private struct QuickSpendingPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: CSSpacing.md) {
      HStack {
        VStack(alignment: .leading, spacing: CSSpacing.xxs) {
          Text("Food")
            .font(CSFont.title3)
            .foregroundStyle(CSColor.primaryText)

          Text("$90 left this month")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
        }

        Spacer()

        Image(systemName: "bolt.fill")
          .font(.headline)
          .foregroundStyle(CSColor.brandGreen)
      }

      VStack(alignment: .leading, spacing: CSSpacing.xs) {
        Text("Amount")
          .font(CSFont.caption)
          .foregroundStyle(CSColor.secondaryText)

        HStack {
          Text("$")
            .font(CSFont.amountMedium)
            .foregroundStyle(CSColor.secondaryText)

          Text("24.50")
            .font(CSFont.amountMedium)
            .foregroundStyle(CSColor.primaryText)

          Spacer()
        }
        .padding(CSSpacing.md)
        .background(CSColor.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))
      }

      HStack {
        Image(systemName: "checkmark")
        Text("Save Spending")
      }
      .font(CSFont.headline)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .padding(.vertical, CSSpacing.sm)
      .background(CSColor.brandGreen)
      .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))
    }
  }
}

private struct BudgetAwarenessPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: CSSpacing.md) {
      HStack {
        VStack(alignment: .leading, spacing: CSSpacing.xxs) {
          Text("Food Budget")
            .font(CSFont.title3)
            .foregroundStyle(CSColor.primaryText)

          Text("$90 remaining")
            .font(CSFont.subheadline)
            .foregroundStyle(CSColor.secondaryText)
        }

        Spacer()

        Text("72%")
          .font(CSFont.caption)
          .foregroundStyle(CSColor.brandGreen)
          .padding(.horizontal, CSSpacing.sm)
          .padding(.vertical, CSSpacing.xs)
          .background(CSColor.brandGreen.opacity(0.14))
          .clipShape(Capsule())
      }

      CSProgressBar(progress: 0.72, tint: CSColor.brandGreen)

      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: CSSpacing.xxs) {
          Text("Spent")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.secondaryText)

          CSAmountText(amount: 260, size: .small, color: CSColor.expense)
        }

        Spacer()

        VStack(alignment: .trailing, spacing: CSSpacing.xxs) {
          Text("Limit")
            .font(CSFont.caption)
            .foregroundStyle(CSColor.secondaryText)

          CSAmountText(amount: 350, size: .small, color: CSColor.primaryText)
        }
      }

      Text("Know when to slow down before the month gets tight.")
        .font(CSFont.footnote)
        .foregroundStyle(CSColor.tertiaryText)
    }
  }
}

#Preview {
  OnboardingView {
    print("Onboarding completed.")
  }
  .preferredColorScheme(.dark)
}
