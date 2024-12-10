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
    @State private var selectedGoal: WorkoutGoalEnum = .open
    @State private var selectedAlert: WorkoutAlertEnum?

    var body: some View {
        let selectedGoalBinding = Binding(get: { selectedGoal },
                                          set: { selectedGoal = $0; workoutStep.goal = $0.goal })
        let selectedAlertBinding = Binding(get: { selectedAlert },
                                           set: { selectedAlert = $0; workoutStep.alert = $0?.alert })
        VStack {
            // TODO: Add custom segmented control picker with swappable options
            Picker("Add a goal", selection: selectedGoalBinding) {
                ForEach(WorkoutGoalEnum.allCases, id: \.self) { goalEnum in
                    Text(goalEnum.goal.description)
                        .tag(goalEnum)
                        .onTapGesture {
                            workoutStep.goal = goalEnum.goal
                        }
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
            selectedGoal = workoutStep.goal.enum
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

enum WorkoutGoalEnum: CaseIterable {
    case open
    case distance
    case time
    case energy

    var goal: WorkoutGoal {
        switch self {
        case .open:
            return .open
        case .distance:
            return .distance(1, .meters)
        case .time:
            return .time(1, .minutes)
        case .energy:
            return .energy(1, .calories)
        }
    }
}
