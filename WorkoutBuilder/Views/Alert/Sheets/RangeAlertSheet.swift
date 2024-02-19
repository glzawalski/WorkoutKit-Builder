//
//  RangeAlertSheet.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/02/24.
//

import SwiftUI
import WorkoutKit

enum RangeAlertType {
    case cadence
    case heartRate
    case power
    case speed
}

struct RangeAlertSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router

    @Binding var alert: (any WorkoutAlert)?
    @State var type: RangeAlertType
    @State var unit: Dimension = UnitFrequency.hertz
    @State var minValue: Double = .zero
    @State var maxValue: Double = .zero
    @State var metric: WorkoutAlertMetric = .average

    var units: [Dimension] {
        switch type {
        case .cadence:
            UnitFrequency.allCases
        case .heartRate:
            UnitFrequency.allCases
        case .power:
            UnitPower.allCases
        case .speed:
            UnitSpeed.allCases
        }
    }

    var body: some View {
        VStack {
            Picker("Unit", selection: $unit) {
                ForEach(units) { unit in
                    Text("\(unit.symbol)")
                        .tag(unit)
                }
            }
            .pickerStyle(.segmented)

            HStack {
                Text("Min")

                TextField("Min", value: $minValue, formatter: NumberFormatter.decimal)
                    .keyboardType(.decimalPad)
            }

            HStack {
                Text("Max")

                TextField("Max", value: $maxValue, formatter: NumberFormatter.decimal)
                    .keyboardType(.decimalPad)
            }

            Button(
                action: {
                    switch type {
                    case .cadence:
                        guard let unit = unit as? UnitFrequency else {
                            return
                        }
                        let min = Measurement(value: minValue, unit: unit)
                        let max = Measurement(value: maxValue, unit: unit)
                        alert = CadenceRangeAlert(target: min...max)
                    case .heartRate:
                        guard let unit = unit as? UnitFrequency else {
                            return
                        }
                        let min = Measurement(value: minValue, unit: unit)
                        let max = Measurement(value: maxValue, unit: unit)
                        alert = HeartRateRangeAlert(target: min...max)
                    case .power:
                        guard let unit = unit as? UnitPower else {
                            return
                        }
                        let min = Measurement(value: minValue, unit: unit)
                        let max = Measurement(value: maxValue, unit: unit)
                        alert = PowerRangeAlert(target: min...max)
                    case .speed:
                        guard let unit = unit as? UnitSpeed else {
                            return
                        }
                        let min = Measurement(value: minValue, unit: unit)
                        let max = Measurement(value: maxValue, unit: unit)
                        alert = SpeedRangeAlert(target: min...max, metric: metric)
                    }
                    dismiss()
                    router.navigateBack()
                },
                label: {
                    Text("Confirm")
                }
            )
        }
        .padding()
        .onChange(of: alert as? CadenceRangeAlert, initial: true) { // TODO: Special modifier?? Generics??
            if let alert = alert as? CadenceRangeAlert {
                unit = alert.target.lowerBound.unit
                minValue = alert.target.lowerBound.value
                maxValue = alert.target.upperBound.value
                metric = alert.metric
            }
        }
    }
}

#Preview {
    RangeAlertSheet(alert: .constant(HeartRateZoneAlert.init(zone: 1)), type: .cadence)
        .environmentObject(Router())
}
