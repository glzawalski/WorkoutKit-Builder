//
//  AddGoalAlertView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 09/12/24.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct AddWarmupView: View {
    @Environment(WorkoutBuilderAppState.self) var state

    var body: some View {
        AddGoalAlertView(workoutStep: Bindable(state).warmup)
    }
}

struct AddCooldownView: View {
    @Environment(WorkoutBuilderAppState.self) var state

    var body: some View {
        AddGoalAlertView(workoutStep: Bindable(state).cooldown)
    }
}

struct AddGoalAlertView: View {
    @Environment(WorkoutBuilderAppState.self) var state
    @Binding var workoutStep: WorkoutStep

    var body: some View {
        VStack {
            GoalSelector(workoutStep: $workoutStep)

            AlertSelector(workoutStep: $workoutStep)
        }
    }
}
