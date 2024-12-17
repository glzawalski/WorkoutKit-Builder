//
//  AlertSelector.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/12/24.
//

import SwiftUI
import WorkoutKit

struct AlertSelector: View {
    @Environment(WorkoutBuilderAppState.self) var state

    @Binding var workoutStep: WorkoutStep

    @State private var selectedAlert: WorkoutAlertEnum?
    @State private var presentAlertInput: Bool = false

    var body: some View {
        let selectedAlertBinding = Binding(get: { selectedAlert },
                                           set: { selectedAlert = $0; workoutStep.alert = $0?.alert })
        
        HStack {
            Text("Add an alert")
            // TODO: Add custom segmented control picker with swappable options
            Picker("Add an alert", selection: selectedAlertBinding) {
                Text("None")
                    .tag(nil as WorkoutAlertEnum?)
                ForEach(state.supportedAlerts, id: \.self) { alert in
                    Text(alert.rawValue)
                        .tag(alert)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: selectedAlert) { _, newValue in
                guard newValue != nil else { return }
                presentAlertInput.toggle()
            }
        }
        .onAppear {
            selectedAlert = (workoutStep.alert as? WorkoutAlertEnumRepresentable)?.enumCase
        }
        .sheet(isPresented: $presentAlertInput) {
            switch selectedAlert {
            case .heartRateRange, .cadenceRange, .powerRange, .speedRange:
                RangeAlerts(
                    workoutStep: $workoutStep,
                    alert: $selectedAlert
                )
            case .heartRateZone, .powerZone:
                ZoneAlerts(
                    workoutStep: $workoutStep,
                    selectedAlert: $selectedAlert
                )
            case .cadenceThreshold, .powerThreshold, .speedThreshold:
                ThresholdAlerts(
                    workoutStep: $workoutStep,
                    alert: $selectedAlert
                )
            case nil:
                EmptyView()
            }
        }
    }
}
