//
//  AddWorkoutStepView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 09/12/24.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct AddWorkoutStepView: View {
    @Environment(\.dismiss) var dismiss

    let activity: HKWorkoutActivityType
    let location: HKWorkoutSessionLocationType

    @Binding var workoutStep: WorkoutStep
    @State private var selectedAlert: WorkoutAlertEnum?

    var body: some View {
        let selectedAlertBinding = Binding(get: { selectedAlert },
                                           set: { selectedAlert = $0; workoutStep.alert = $0?.alert })
        VStack {
            // TODO: Add custom segmented control picker with swappable options
            Picker("Add a goal", selection: $workoutStep.goal) {
                ForEach(WorkoutGoal.allCases) { goal in
                    Text(goal.description)
                        .tag(goal)
                }
            }
            .pickerStyle(.segmented)

            // TODO: Add custom segmented control picker with swappable options
            Picker("Add an alert", selection: selectedAlertBinding) {
                ForEach(activity.supportedAlerts(location: location), id: \.self) { alertEnum in
                    Text(alertEnum.alert.description)
                        .tag(alertEnum)
                        .onTapGesture {
                            workoutStep.alert = alertEnum.alert
                        }
                }
            }
            .pickerStyle(.segmented)

            Button("Add") {
                dismiss()
            }
        }
        .onAppear {
            selectedAlert = workoutStep.alert?.enum
        }
    }
}

#Preview {
    var workoutStep: WorkoutStep = .init(goal: .energy(1, .calories),
                                         alert: .heartRate(zone: 1))

    AddWorkoutStepView(
        activity: .americanFootball,
        location: .indoor,
        workoutStep: .init(get: { workoutStep },
                           set: { workoutStep = $0 })
    )
}
