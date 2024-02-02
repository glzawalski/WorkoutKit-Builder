//
//  WorkoutAlertSection.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/08/23.
//

import SwiftUI
import WorkoutKit

struct WorkoutAlertSection: View {
    @Binding var type: AlertType?
    @Binding var unit: AlertUnit?
    @Binding var metric: AlertMetric?

    @Binding var thresholdValue: Double
    @Binding var rangeMinValue: Double
    @Binding var rangeMaxValue: Double
    @Binding var zoneValue: Int

    var body: some View {
        Section("Alert") {
            typePicker

            switch type {
            case .cadenceRange:
                frequencyUnitPicker
                rangeValueInput

            case .cadenceThreshold:
                frequencyUnitPicker
                thresholdValueInput

            case .heartRateRange:
                frequencyUnitPicker
                rangeValueInput

            case .heartRateZone:
                frequencyUnitPicker
                zoneValueInput

            case .powerRange:
                powerUnitPicker
                rangeValueInput

            case .powerThreshold:
                powerUnitPicker
                thresholdValueInput

            case .powerZone:
                powerUnitPicker
                zoneValueInput

            case .speedRange:
                speedUnitPicker
                rangeValueInput
                metricPicker

            case .speedThreshold:
                speedUnitPicker
                thresholdValueInput
                metricPicker

            case .none:
                EmptyView()
            }
        }
    }
}

extension WorkoutAlertSection {
    var typePicker: some View {
        Picker("Type", selection: $type) {
            Text("None")
                .tag(nil as AlertType?)
            ForEach(AlertType.allCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as AlertType?)
            }
        }
    }

    var frequencyUnitPicker: some View {
        Picker("Unit", selection: $unit) {
            Text("None")
                .tag(nil as AlertUnit?)
            ForEach(AlertUnit.frequencyCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as AlertUnit?)
            }
        }
    }

    var powerUnitPicker: some View {
        Picker("Unit", selection: $unit) {
            Text("None")
                .tag(nil as AlertUnit?)
            ForEach(AlertUnit.powerCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as AlertUnit?)
            }
        }
    }

    var speedUnitPicker: some View {
        Picker("Unit", selection: $unit) {
            Text("None")
                .tag(nil as AlertUnit?)
            ForEach(AlertUnit.speedCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as AlertUnit?)
            }
        }
    }

    var metricPicker: some View {
        Picker("Metric", selection: $metric) {
            Text("None")
                .tag(nil as AlertMetric?)
            ForEach(AlertMetric.allCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as AlertMetric?)
            }
        }
    }

    var thresholdValueInput: some View {
        HStack {
            Text("Target Value")
            TextField("Target Value", value: $thresholdValue, formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
        }
    }

    var rangeValueInput: some View {
        Group {
            HStack {
                Text("Min Value")
                TextField("Range Min Value", value: $rangeMinValue, formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Max Value")
                TextField("Range Max Value", value: $rangeMaxValue, formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    var zoneValueInput: some View {
        HStack {
            Text("Zone Value")
            TextField("Zone Value", value: $zoneValue, formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    WorkoutAlertSection(type: .constant(.cadenceThreshold), unit: .constant(.hertz), metric: .constant(nil), thresholdValue: .constant(.zero), rangeMinValue: .constant(.zero), rangeMaxValue: .constant(.zero), zoneValue: .constant(.zero))
}

enum AlertType: String, CaseIterable {
    case cadenceRange = "Cadence Range"
    case cadenceThreshold = "Cadence Threshold"
    case heartRateRange = "Heart Rate Range"
    case heartRateZone = "Heart Rate Zone"
    case powerRange = "Power Range"
    case powerThreshold = "Power Threshold"
    case powerZone = "Power Zone"
    case speedRange = "Speed Range"
    case speedThreshold = "Speed Threshold"
}

enum AlertUnit: String {
    case megahertz = "Megahertz"
    case kilohertz = "Kilohertz"
    case hertz = "Hertz"

    static var frequencyCases: [AlertUnit] {
        [.megahertz, .kilohertz, .hertz]
    }

    case kilowatts = "Kilowatts"
    case watts = "Watts"
    case milliwatts = "Milliwatts"

    static var powerCases: [AlertUnit] {
        [.kilowatts, .watts, .milliwatts]
    }

    case metersPerSecond = "Meters per second"
    case kilometersPerHour = "Kilometers per hour"
    case milesPerHour = "Miles per hour"
    case knots = "Knots"

    static var speedCases: [AlertUnit] {
        [.metersPerSecond, .kilometersPerHour, .milesPerHour, .knots]
    }
}

enum AlertMetric: String, CaseIterable {
    case average = "Average"
    case current = "Current"
}
