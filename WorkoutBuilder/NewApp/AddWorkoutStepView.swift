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

    @Binding var goal: WorkoutGoal
    @Binding var alert: (any WorkoutAlert)?
    @State private var selectedAlert: WorkoutAlertEnum?

    var body: some View {
        VStack {
            // TODO: Add custom segmented control picker with swappable options
            Picker("Add a goal", selection: $goal) {
                ForEach(WorkoutGoal.allCases) { goal in
                    Text(goal.description)
                        .tag(goal)
                }
            }
            .pickerStyle(.segmented)

            // TODO: Add custom segmented control picker with swappable options
            Picker("Add an alert", selection: Binding(get: { selectedAlert },
                                                      set: { selectedAlert = $0; alert = $0?.alert })) {
                ForEach(activity.supportedAlerts(location: location), id: \.self) { alertEnum in
                    Text(alertEnum.alert.description)
                        .tag(alertEnum)
                        .onTapGesture {
                            alert = alertEnum.alert
                        }
                }
            }
            .pickerStyle(.segmented)

            Button("Add") {
                dismiss()
            }
        }
        .onAppear {
            selectedAlert = alert?.enum
        }
    }
}

#Preview {
    AddWorkoutStepView(
        activity: .americanFootball,
        location: .indoor,
        goal: .constant(.open),
        alert: .constant(nil)
    )
}
