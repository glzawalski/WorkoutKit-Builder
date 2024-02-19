//
//  ThresholdAlertSheet.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 16/02/24.
//

import SwiftUI
import WorkoutKit

enum ThresholdAlertType {
    case cadence
    case power
    case speed
}

struct ThresholdAlertSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router

    @Binding var alert: (any WorkoutAlert)?
    @State var type: ThresholdAlertType
    @State var unit: Dimension = UnitFrequency.hertz
    @State var value: Double = .zero
    @State var metric: WorkoutAlertMetric = .average

    var units: [Dimension] {
        switch type {
        case .cadence:
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
                Text("Threshold")

                TextField("Threshold", value: $value, formatter: NumberFormatter.decimal)
                    .keyboardType(.decimalPad)
            }

            Button(
                action: {
                    switch type {
                    case .cadence:
                        guard let unit = unit as? UnitFrequency else {
                            return
                        }
                        let measurement = Measurement(value: value, unit: unit)
                        alert = CadenceThresholdAlert(target: measurement)
                    case .power:
                        guard let unit = unit as? UnitPower else {
                            return
                        }
                        let measurement = Measurement(value: value, unit: unit)
                        alert = PowerThresholdAlert(target: measurement)
                    case .speed:
                        guard let unit = unit as? UnitSpeed else {
                            return
                        }
                        let measurement = Measurement(value: value, unit: unit)
                        alert = SpeedThresholdAlert(target: measurement, metric: metric)
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
        .onChange(of: alert as? CadenceThresholdAlert, initial: true) { // TODO: Special modifier?? Generics??
            if let alert = alert as? CadenceThresholdAlert {
                unit = alert.target.unit
                value = alert.target.value
                metric = alert.metric
            }
        }
    }
}

#Preview {
    ThresholdAlertSheet(alert: .constant(nil), type: .cadence)
        .environmentObject(Router())
}
