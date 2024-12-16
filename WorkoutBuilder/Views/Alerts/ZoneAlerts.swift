//
//  ZoneAlerts.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/12/24.
//

import SwiftUI
import WorkoutKit

struct ZoneAlerts: View {
    @Binding var workoutStep: WorkoutStep
    @Binding var selectedAlert: WorkoutAlertEnum?

    @State private var value: Int = 1
    let step = 1
    let range = 1...50 // TODO: Validate realistically possible zones

    var body: some View {
        VStack {
            Stepper(value: valueBinding, in: range, step: step) {
                Text("Current: \(value) in \(range.description) " +
                     "stepping by \(step)")
            }
        }
    }

    var valueBinding: Binding<Int> {
        Binding(get: { value }, set: { updateValue($0) })
    }

    func updateValue(_ newValue: Int) {
        value = newValue
//        workoutStep.alert = selectedAlert?.zoneAlert(with: newValue)
    }
}
