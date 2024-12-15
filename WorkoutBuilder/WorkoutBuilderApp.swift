//
//  WorkoutBuilderApp.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 20/06/23.
//

import SwiftUI
import HealthKit

@main
struct WorkoutBuilderApp: App {
    @State private var state: WorkoutBuilderAppState = .init()

    var body: some Scene {
        WindowGroup {
            WorkoutList()
                .environment(state)
        }
    }
}
