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

    @State private var selectedAlertZone: Int = 1
    
    var body: some View {
        Text("Zone input") // TODO: Add text field or stepper for picking zone
    }
}
