//
//  RangeAlerts.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/12/24.
//

import SwiftUI
import WorkoutKit

extension RangeAlerts: View {
    var body: some View {
        HStack {
            Text("Range:")

            TextField("Range min", value: minValueBinding, formatter: NumberFormatter())
            TextField("Range max", value: maxValueBinding, formatter: NumberFormatter())

            frequencyUnitPicker
            powerUnitPicker
            speedUnitPicker
        }
    }

    var frequencyUnitPicker: some View {
        Picker("Unit", selection: frequencyUnitBinding) {
            ForEach(UnitFrequency.allCases, id: \.self) { unit in
                Text(unit.symbol)
                    .tag(unit)
            }
        }
        .opacity(alert == .cadenceRange || alert == .heartRateRange ? 1 : 0)
        .frame(maxWidth: alert == .cadenceRange || alert == .heartRateRange ? nil : 0, maxHeight: alert == .cadenceRange || alert == .heartRateRange ? nil : 0)
    }

    var powerUnitPicker: some View {
        Picker("Unit", selection: frequencyUnitBinding) {
            ForEach(UnitFrequency.allCases, id: \.self) { unit in
                Text(unit.symbol)
                    .tag(unit)
            }
        }
        .opacity(alert == .powerRange ? 1 : 0)
        .frame(maxWidth: alert == .powerRange ? nil : 0, maxHeight: alert == .powerRange ? nil : 0)
    }

    var speedUnitPicker: some View {
        Picker("Unit", selection: frequencyUnitBinding) {
            ForEach(UnitFrequency.allCases, id: \.self) { unit in
                Text(unit.symbol)
                    .tag(unit)
            }
        }
        .opacity(alert == .speedRange ? 1 : 0)
        .frame(maxWidth: alert == .speedRange ? nil : 0, maxHeight: alert == .speedRange ? nil : 0)
    }
}

struct RangeAlerts {
    @Binding var workoutStep: WorkoutStep
    @Binding var alert: WorkoutAlertEnum?

    @State private var minValue: Double = 1
    @State private var maxValue: Double = 2

    @State private var unitFrequency: UnitFrequency = .hertz
    @State private var unitPower: UnitPower = .watts
    @State private var unitSpeed: UnitSpeed = .metersPerSecond

    @State private var metric: WorkoutAlertMetric = .average
}

// MARK: - Min value
private extension RangeAlerts {
    var minValueBinding: Binding<Double> {
        Binding(get: { minValue }, set: { updateMinValue($0) })
    }

    func updateMinValue(_ newValue: Double) {
        guard newValue > 0 else { return }
        guard newValue < maxValue else { return }
        minValue = newValue
        workoutStep.alert = createAlert()
    }
}

// MARK: - Max value
private extension RangeAlerts {
    var maxValueBinding: Binding<Double> {
        Binding(get: { maxValue }, set: { updateMaxValue($0) })
    }

    func updateMaxValue(_ newValue: Double) {
        guard newValue > minValue else { return }
        maxValue = newValue
        workoutStep.alert = createAlert()
    }
}

// MARK: - Units
private extension RangeAlerts {
    // MARK: Frequency
    var frequencyUnitBinding: Binding<UnitFrequency> {
        Binding(get: { unitFrequency }, set: { updateUnit($0) })
    }

    func updateUnit(_ unit: UnitFrequency) {
        unitFrequency = unit
        workoutStep.alert = createAlert()
    }

    var frequencyRangeMeasurement: ClosedRange<Measurement<UnitFrequency>> {
        let min = Measurement(value: minValue, unit: unitFrequency)
        let max = Measurement(value: maxValue, unit: unitFrequency)
        return min...max
    }

    // MARK: Power
    var powerUnitBinding: Binding<UnitPower> {
        Binding(get: { unitPower }, set: { updateUnit($0) })
    }

    func updateUnit(_ unit: UnitPower) {
        unitPower = unit
        workoutStep.alert = createAlert()
    }

    var powerRangeMeasurement: ClosedRange<Measurement<UnitPower>> {
        let min = Measurement(value: minValue, unit: unitPower)
        let max = Measurement(value: maxValue, unit: unitPower)
        return min...max
    }

    // MARK: Speed
    var speedUnitBinding: Binding<UnitSpeed> {
        Binding(get: { unitSpeed }, set: { updateUnit($0) })
    }

    func updateUnit(_ unit: UnitSpeed) {
        unitSpeed = unit
        workoutStep.alert = createAlert()
    }

    var speedRangeMeasurement: ClosedRange<Measurement<UnitSpeed>> {
        let min = Measurement(value: minValue, unit: unitSpeed)
        let max = Measurement(value: maxValue, unit: unitSpeed)
        return min...max
    }
}

// MARK: - WorkoutAlert
private extension RangeAlerts {
    func createAlert() -> (any WorkoutAlert)? {
        switch alert {
        case .cadenceRange:
            return CadenceRangeAlert(target: frequencyRangeMeasurement)
        case .heartRateRange:
            return HeartRateRangeAlert(target: frequencyRangeMeasurement)
        case .powerRange:
            return PowerRangeAlert(target: powerRangeMeasurement) // TODO: Add option for power metric on newer iOS 17.4
        case .speedRange:
            return SpeedRangeAlert(target: speedRangeMeasurement, metric: metric)
        default:
            return nil
        }
    }
}
