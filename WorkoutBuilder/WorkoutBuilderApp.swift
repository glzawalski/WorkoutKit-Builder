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
    var body: some Scene {
        WindowGroup {
            PrimaryView()
                .environmentObject(CustomWorkoutModel())
                .environmentObject(Router())
        }
    }
}
