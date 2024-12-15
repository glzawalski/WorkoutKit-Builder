//
//  RangeAlerts.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/12/24.
//

import SwiftUI
import WorkoutKit

struct RangeAlerts: View {
    @Binding var workoutStep: WorkoutStep
    @Binding var selectedAlert: WorkoutAlertEnum?

    @State private var frequencyRange = Measurement(value: 1, unit: UnitFrequency.hertz)...Measurement(value: 2, unit: UnitFrequency.hertz)
    @State private var powerRange = Measurement(value: 1, unit: UnitPower.watts)...Measurement(value: 2, unit: UnitPower.watts)
    @State private var speedRange = Measurement(value: 1, unit: UnitSpeed.metersPerSecond)...Measurement(value: 2, unit: UnitSpeed.metersPerSecond)

    var body: some View {
        Text("Range input")
    }
}
