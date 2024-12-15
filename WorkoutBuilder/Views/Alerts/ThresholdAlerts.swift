//
//  ThresholdAlerts.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/12/24.
//

import SwiftUI
import WorkoutKit

struct ThresholdAlerts: View {
    @Binding var workoutStep: WorkoutStep
    @Binding var alert: WorkoutAlertEnum?

    @State private var frequency = Measurement(value: 1, unit: UnitFrequency.hertz)
    @State private var power = Measurement(value: 1, unit: UnitPower.watts)
    @State private var speedValue: Double = 1
    @State private var speedUnit: UnitSpeed = .metersPerSecond
    @State private var metric: WorkoutAlertMetric = .average

    var body: some View {
        VStack {
            Text("Alert threshold value:")

            frequencyAlert

            powerAlert

            speedAlert
        }
    }
}

// MARK: - Frequency alert
extension ThresholdAlerts {
    private var frequencyAlert: some View {
        TextField("Alert threshold value:", value: frequencyBinding, formatter: NumberFormatter())
            .opacity(alert == .cadenceThreshold ? 1 : 0)
            .frame(maxWidth: alert == .cadenceThreshold ? nil : 0, maxHeight: alert == .cadenceThreshold ? nil : 0)
    }

    var frequencyBinding: Binding<Measurement<UnitFrequency>> {
        Binding(get: { frequency }, set: { updateFrequency($0) })
    }

    func updateFrequency(_ frequency: Measurement<UnitFrequency>) {
        self.frequency = frequency
        workoutStep.alert = alert?.thresholdAlert(with: frequency)
    }
}

// MARK: - Power alert
extension ThresholdAlerts {
    private var powerAlert: some View {
        TextField("Alert threshold value:", value: powerBinding, formatter: NumberFormatter())
            .opacity(alert == .powerThreshold ? 1 : 0)
            .frame(maxWidth: alert == .powerThreshold ? nil : 0, maxHeight: alert == .powerThreshold ? nil : 0)
    }

    var powerBinding: Binding<Measurement<UnitPower>> {
        Binding(get: { power }, set: { updatePower($0) })
    }

    func updatePower(_ power: Measurement<UnitPower>) {
        self.power = power
        workoutStep.alert = alert?.thresholdAlert(with: power)
    }
}

// MARK: - Speed alert
private extension ThresholdAlerts {
    var speedAlert: some View {
        HStack {
            TextField("Alert threshold value:", value: speedValueBinding, formatter: NumberFormatter())

            Picker("Speed unit", selection: speedUnitBinding) {
                ForEach(UnitSpeed.allCases, id: \.self) { unit in
                    Text(unit.symbol)
                        .tag(unit)
                }
            }

            Picker("Alert metric", selection: speedMetricBinding) {
                ForEach(WorkoutAlertMetric.allCases, id: \.self) { metric in
                    Text(metric.description)
                        .tag(metric)
                }
            }
        }
        .opacity(alert == .speedThreshold ? 1 : 0)
        .frame(maxWidth: alert == .speedThreshold ? nil : 0, maxHeight: alert == .speedThreshold ? nil : 0)
    }

    var speedValueBinding: Binding<Double> {
        Binding(get: { speedValue }, set: { updateSpeedValue($0) })
    }

    func updateSpeedValue(_ value: Double) {
        speedValue = value
        workoutStep.alert = alert?.thresholdAlert(value: speedValue, unit: speedUnit, metric: metric)
    }

    var speedUnitBinding: Binding<UnitSpeed> {
        Binding(get: { speedUnit }, set: { updateSpeedUnit($0) })
    }

    func updateSpeedUnit(_ unit: UnitSpeed) {
        speedUnit = unit
        workoutStep.alert = alert?.thresholdAlert(value: speedValue, unit: speedUnit, metric: metric)
    }

    var speedMetricBinding: Binding<WorkoutAlertMetric> {
        Binding(get: { metric }, set: { updateSpeedMetric($0) })
    }

    func updateSpeedMetric(_ metric: WorkoutAlertMetric) {
        self.metric = metric
        workoutStep.alert = alert?.thresholdAlert(value: speedValue, unit: speedUnit, metric: metric)
    }
}
