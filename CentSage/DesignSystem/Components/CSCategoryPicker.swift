//
//  CSCategoryPicker.swift
//  CentSage
//

import SwiftUI

struct CSCategoryPicker: View {
  static let transactionCategories = [
    "Food",
    "Home",
    "Work",
    "Transportation",
    "Entertainment",
    "Leisure",
    "Health",
    "Gift",
    "Shopping",
    "Investment",
    "Other"
  ]
  
  let title: String
  let categories: [String]
  @Binding var selection: String
  var includesAllOption = false
  
  private var options: [String] {
    includesAllOption ? ["All"] + categories : categories
  }
  
  var body: some View {
    Menu {
      Picker(title, selection: $selection) {
        ForEach(options, id: \.self) { category in
          Text(category).tag(category)
        }
      }
    } label: {
      HStack(spacing: CSSpacing.sm) {
        Image(systemName: "line.3.horizontal.decrease.circle.fill")
          .font(.title3)
          .foregroundStyle(CSColor.brandGreen)
          .frame(width: 32, height: 32)
          .background(CSColor.brandGreen.opacity(0.12))
          .clipShape(RoundedRectangle(cornerRadius: CSRadius.medium, style: .continuous))

        VStack(alignment: .leading, spacing: 2) {
          Text(title.uppercased())
            .font(CSFont.caption)
            .foregroundStyle(CSColor.tertiaryText)

          Text(selection)
            .font(CSFont.headline)
            .foregroundStyle(CSColor.primaryText)
        }

        Spacer()

        Image(systemName: "chevron.down")
          .font(.footnote.weight(.semibold))
          .foregroundStyle(CSColor.secondaryText)
      }
    }
    .padding(.horizontal, CSSpacing.md)
    .padding(.vertical, CSSpacing.sm)
    .background(CSColor.cardBackground)
    .clipShape(RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: CSRadius.large, style: .continuous)
        .stroke(CSColor.border, lineWidth: 1)
    }
    .csCardShadow(CSShadow.transactionCard)
    .buttonStyle(.plain)
    .tint(CSColor.brandGreen)
  }
}
