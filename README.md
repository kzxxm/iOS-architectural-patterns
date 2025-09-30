# Mobile App Architecture Patterns (iOS)

This repo contains my learnings about different architecture patterns for mobile app development, my documented notes about each of them as well as a simple demo project using each pattern.


## 📚 What's Inside

This repository contains **6 major iOS architecture patterns** with:

- ✅ **Complete demo projects** using SwiftUI
- ✅ **Detailed documentation** for each pattern
- ✅ **Real-world examples** with a Todo app
- ✅ **Pros/cons analysis** for each approach
- ✅ **Decision-making cheat sheet**
- ✅ **Best practices** and implementation tips


## 🗂️ Repository Structure
```
📦 iOS-Architecture-Patterns      
├── 📁 MVC/
│   ├── 📱 MVC-Demo/                # Xcode project
│   └── 📄 MVC.md                   # MVC documentation
├── 📁 MVP/
│   ├── 📱 MVP-Demo/                # Xcode project
│   └── 📄 MVP.md                   # MVP documentation
├── 📁 MVVM/
│   ├── 📱 MVVM-Demo/               # Xcode project
│   └── 📄 MVVM.md                  # MVVM documentation
├── 📁 MVI/
│   ├── 📱 MVI-Demo/                # Xcode project
│   └── 📄 MVI.md                   # MVI documentation
├── 📁 TCA/
│   ├── 📱 TCA-Demo/                # Xcode project
│   └── 📄 TCA.md                   # TCA documentation
├── 📁 VIPER/
│   ├── 📱 VIPER-Demo/              # Xcode project
│   └── 📄 VIPER.md                 # VIPER documentation
├── 📋 CheatSheet.md    
└── 📄 README.md                    # This file`
```

## 🔗 Quick Links

|Architecture|Complexity|Best For|Demo Project|
|---|---|---|---|
|**[MVC](MVC/)**|🟢 Low|Simple apps, prototypes|[MVC Demo](MVC/MVC%20Demo)|
|**[MVP](MVP/)**|🟡 Medium|Testable apps, clear separation|[MVP Demo](MVP/MVP%20Demo)|
|**[MVVM](MVVM/)**|🟡 Medium-High|SwiftUI apps, reactive UIs|[MVVM Demo](MVVM/MVVM%20Demo)|
|**[MVI](MVI/)**|🔴 High|Complex state, predictable apps|[MVI Demo](MVI/MVI%20Demo)|
|**[TCA](TCA/)**|🔴 Very High|Complex apps, time-travel debugging|[TCA Demo](TCA/TCA%20Demo)|
|**[VIPER](VIPER/)**|⚫ Extreme|Enterprise apps, large teams|[VIPER Demo](VIPER/VIPER%20demo)|

### 📱 Demo App Features

Each demo implements the same **Todo App** with more functionality through each iteration, some of which is listed below...

- ➕ Add todos
- ✅ Mark as complete/undo
- 🔍 Search functionality
- 🏷️ Priority levels
- 💾 Data persistence

## 🧭 Choosing the Right Architecture

### 🤔 Not Sure Which to Use?

```
New to iOS?        →   MVC
Using SwiftUI?     →   MVVM
Need testing?      →   MVP/TCA
Complex state?     →   TCA/MVI
Large team?        →   VIPER
Time pressure?     →   MVC/MVVM
```

### 📊 Comparison Matrix

|Factor|MVC|MVP|MVVM|MVI|TCA|VIPER|
|---|---|---|---|---|---|---|
|**Learning Curve**|⭐|⭐⭐|⭐⭐⭐|⭐⭐⭐⭐|⭐⭐⭐⭐⭐|⭐⭐⭐⭐⭐|
|**Testability**|⭐⭐|⭐⭐⭐⭐|⭐⭐⭐⭐|⭐⭐⭐⭐⭐|⭐⭐⭐⭐⭐|⭐⭐⭐⭐⭐|
|**SwiftUI Fit**|⭐|⭐⭐|⭐⭐⭐⭐⭐|⭐⭐⭐|⭐⭐⭐⭐⭐|⭐|
|**Team Scale**|⭐⭐|⭐⭐⭐|⭐⭐⭐|⭐⭐⭐⭐|⭐⭐⭐⭐⭐|⭐⭐⭐⭐⭐|

## 📖 Detailed Guides

### 🏗️ Architecture Patterns

- **[MVC (Model-View-Controller)](MVC)**

    - Traditional iOS pattern
    - Simple and familiar
    - Best for: Small projects, learning
    
- **[MVP (Model-View-Presenter)](MVP)**
    
    - Passive view with presenter coordination
    - Excellent testability
    - Best for: Testable apps, UIKit
      
- **[MVVM (Model-View-ViewModel)](MVVM)**
    
    - Reactive data binding
    - Perfect SwiftUI integration
    - Best for: SwiftUI apps, reactive UIs
      
- **[MVI (Model-View-Intent)](MVI)**
    
    - Unidirectional data flow
    - Immutable state management
    - Best for: Complex state, predictability
      
- **[TCA (The Composable Architecture)](TCA)**
    
    - Point-Free's opinionated architecture
    - Time-travel debugging
    - Best for: Complex apps, composability
      
- **[VIPER (View-Interactor-Presenter-Entity-Router)](VIPER)**
    
    - Maximum separation of concerns
    - Highly modular
    - Best for: Enterprise apps, large teams


## 🎓 Learning Path

```
1. Start: MVC (learn iOS basics)
↓ 2. Learn: MVP (understand separation)
  ↓ 3. Practice: MVVM (master SwiftUI)
    ↓ 4. Explore: MVI (unidirectional flow)
      ↓ 5. Advanced: TCA (composition & effects)
        ↓ 6. Enterprise: VIPER (maximum modularity)
```


