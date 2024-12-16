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

    @State private var frequencyValue: Double = 1
    @State private var frequencyUnit: UnitFrequency = .hertz

    @State private var powerValue: Double = 1
    @State private var powerUnit: UnitPower = .watts

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
private extension ThresholdAlerts {
    private var frequencyAlert: some View {
        HStack {
            TextField("Alert threshold value:", value: frequencyValueBinding, formatter: NumberFormatter())
            Picker("Frequency unit", selection: frequencyUnitBinding) {
                ForEach(UnitFrequency.allCases, id: \.self) { unit in
                    Text(unit.symbol)
                        .tag(unit)
                }
            }
        }
        .opacity(alert == .cadenceThreshold ? 1 : 0)
        .frame(maxWidth: alert == .cadenceThreshold ? nil : 0, maxHeight: alert == .cadenceThreshold ? nil : 0)
    }

    var frequencyValueBinding: Binding<Double> {
        Binding(get: { frequencyValue }, set: { updateFrequencyValue($0) })
    }

    func updateFrequencyValue(_ frequency: Double) {
        frequencyValue = frequency
//        workoutStep.alert = alert?.thresholdAlert(with: frequencyMeasurement)
    }

    var frequencyUnitBinding: Binding<UnitFrequency> {
        Binding(get: { frequencyUnit }, set: { updateFrequencyUnit($0) })
    }

    func updateFrequencyUnit(_ unit: UnitFrequency) {
        frequencyUnit = unit
//        workoutStep.alert = alert?.thresholdAlert(with: frequencyMeasurement)
    }

    var frequencyMeasurement: Measurement<UnitFrequency> {
        Measurement(value: frequencyValue, unit: frequencyUnit)
    }
}

// MARK: - Power alert
private extension ThresholdAlerts {
    private var powerAlert: some View {
        HStack {
            TextField("Alert threshold value:", value: powerValueBinding, formatter: NumberFormatter())
            Picker("Power unit", selection: powerUnitBinding) {
                ForEach(UnitPower.allCases, id: \.self) { unit in
                    Text(unit.symbol)
                        .tag(unit)
                }
            }
        }
        .opacity(alert == .powerThreshold ? 1 : 0)
        .frame(maxWidth: alert == .powerThreshold ? nil : 0, maxHeight: alert == .powerThreshold ? nil : 0)
    }

    var powerValueBinding: Binding<Double> {
        Binding(get: { powerValue }, set: { updatePowerValue($0) })
    }

    func updatePowerValue(_ power: Double) {
        powerValue = power
//        workoutStep.alert = alert?.thresholdAlert(with: powerMeasurement)
    }

    var powerUnitBinding: Binding<UnitPower> {
        Binding(get: { powerUnit }, set: { updatePowerUnit($0) })
    }

    func updatePowerUnit(_ unit: UnitPower) {
        powerUnit = unit
//        workoutStep.alert = alert?.thresholdAlert(with: powerMeasurement)
    }

    var powerMeasurement: Measurement<UnitPower> {
        Measurement(value: powerValue, unit: powerUnit)
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
//        workoutStep.alert = alert?.thresholdAlert(with: speedMeasurement, metric: metric)
    }

    var speedUnitBinding: Binding<UnitSpeed> {
        Binding(get: { speedUnit }, set: { updateSpeedUnit($0) })
    }

    func updateSpeedUnit(_ unit: UnitSpeed) {
        speedUnit = unit
//        workoutStep.alert = alert?.thresholdAlert(with: speedMeasurement, metric: metric)
    }

    var speedMetricBinding: Binding<WorkoutAlertMetric> {
        Binding(get: { metric }, set: { updateSpeedMetric($0) })
    }

    func updateSpeedMetric(_ metric: WorkoutAlertMetric) {
        self.metric = metric
//        workoutStep.alert = alert?.thresholdAlert(with: speedMeasurement, metric: metric)
    }

    var speedMeasurement: Measurement<UnitSpeed> {
        Measurement(value: speedValue, unit: speedUnit)
    }
}
