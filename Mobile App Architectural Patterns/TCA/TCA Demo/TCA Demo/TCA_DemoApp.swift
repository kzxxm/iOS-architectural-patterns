//
//  TCA_DemoApp.swift
//  TCA Demo
//
//  Created by Kassim Mirza on 29/09/2025.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCA_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: TodoReducer.State()) {
                    TodoReducer()
                }
            )
        }
    }
}
