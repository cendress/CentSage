# 💰 CentSage

CentSage is a simple iOS budgeting app for tracking spending, managing budgets, and understanding where your money goes.

The app is designed for people who want a fast, manual way to stay on top of their finances without linking bank accounts or dealing with complicated finance tools.

## ✨ Overview

CentSage helps users quickly log spending, review transactions, monitor budget progress, and understand monthly financial patterns.

The core idea is simple: budgeting should feel fast, calm, and easy to maintain.

## 🚀 Features

- Create budgets by category
- Add quick spending entries directly from a budget
- Manually log income and expenses
- Add transaction notes, dates, and categories
- Review recent transaction history
- Track monthly income vs. expenses
- View budget progress and remaining amounts
- Review lightweight spending reports and month-over-month trends
- Use the app without linking a bank account

## 🧭 User Flow

CentSage is built around quick, low-friction budgeting.

Users can open the app, choose a budget, enter a spending amount, and save it in seconds. For more detailed tracking, users can also create full transactions with a category, date, and note.

Quick spending entries are designed to keep budgeting simple while still helping users build a useful financial history over time.

## 📸 Screenshots

<p align="center">
<img width="250" alt="03" src="https://github.com/user-attachments/assets/36859b5a-eefa-44a5-b0dc-a46eb07ab357" />
<img width="250" alt="01" src="https://github.com/user-attachments/assets/c372f795-243e-4d6b-b646-7169f3f10a24" />
<img width="250" alt="04" src="https://github.com/user-attachments/assets/6af9bd31-0c68-4066-8df9-0e4ff4ca46bd" />
</p>

## 🛠 Installation

Clone this repository:

```bash
git clone https://github.com/cendress/CentSage.git
```

Open the project in Xcode:

```bash
open CentSage.xcodeproj
```

Build and run the app on a simulator or physical iOS device.

## 📋 Requirements

- iOS 18.6+
- Xcode 14.0+
- SwiftUI
- Core Data

## 🧱 Architecture

CentSage is built with SwiftUI and Core Data.

The app is organized around feature-based areas such as budgets, transactions, reports, onboarding, and settings. Shared styling and reusable UI elements are handled through a design system to keep the interface consistent across the app.

The app uses local storage, so financial data is stored on the user’s device.

## 🔒 Privacy

CentSage does not currently require account creation or bank linking.

Financial information is entered manually and stored locally on the device. The app is designed for users who want control over what financial data they track.

## 🎯 Product Direction

CentSage focuses on simple manual budgeting.

Instead of trying to replace full-featured finance platforms, CentSage aims to make everyday money tracking fast, clear, and less overwhelming.

## 🤝 Contributing

Contributions are welcome.

Feel free to open an issue or submit a pull request if you have ideas, bug fixes, or improvements.

## 📧 Contact

Christopher Endress  
[centsageapp@gmail.com](mailto:centsageapp@gmail.com)
