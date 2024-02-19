//
//  AlertView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 05/02/24.
//

import SwiftUI
import WorkoutKit

struct AlertView: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    @Binding var alert: (any WorkoutAlert)?
    @State var alertEnum: WorkoutAlertEnum?
    @State var presentSheet = false

    var body: some View {
        VStack {
            AlertItem(alertEnum: nil, selected: self.alertEnum == nil)
                .onTapGesture {
                    alert = nil
                    alertEnum = nil
                    router.navigateBack()
                }

            ForEach(model.supportedAlerts, id: \.self) { alert in
                AlertItem(alertEnum: alert, selected: self.alertEnum == alert)
                    .onTapGesture {
                        alertEnum = alert
                        presentSheet.toggle()
                    }
            }
        }
        .onChange(of: alert as? CadenceRangeAlert, initial: true) { // TODO: Special modifier?? Generics??
            if let alert {
                alertEnum = alert.enum
            }
        }
        .onChange(of: alert as? CadenceThresholdAlert, initial: true) {
            if let alert {
                alertEnum = alert.enum
            }
        }
        .navigationTitle("Alert")
        .sheet(
            isPresented: $presentSheet,
            onDismiss: {
                alertEnum = alert?.enum
            },
            content: {
                Group {
                    switch alertEnum {
                    case .cadenceRange:
                        RangeAlertSheet(alert: $alert, type: .cadence)
                    case .cadenceThreshold:
                        ThresholdAlertSheet(alert: $alert, type: .cadence)
                    case .heartRateRange:
                        RangeAlertSheet(alert: $alert, type: .heartRate)
                    case .heartRateZone:
                        ZoneAlertSheet(alert: $alert, type: .heartRate)
                    case .powerRange:
                        RangeAlertSheet(alert: $alert, type: .power)
                    case .powerThreshold:
                        ThresholdAlertSheet(alert: $alert, type: .power)
                    case .powerZone:
                        ZoneAlertSheet(alert: $alert, type: .power)
                    case .speedRange:
                        RangeAlertSheet(alert: $alert, type: .speed)
                    case .speedThreshold:
                        ThresholdAlertSheet(alert: $alert, type: .speed)
                    case .none:
                        EmptyView()
                    }
                }
                .presentationDetents([.height(200)])
            }
        )
    }
}

struct AlertItem: View {
    let alertEnum: WorkoutAlertEnum?
    let selected: Bool

    var body: some View {
        VStack {
            Text("\(alertEnum?.alert.description ?? "No alert")")
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(selected ? .blue : .black, lineWidth: 5)
        )
    }
}

#Preview {
    let model = CustomWorkoutModel()
    model.activityType = .running
    model.locationType = .outdoor

    return AlertView(alert: .constant(HeartRateZoneAlert(zone: 1)))
        .environmentObject(model)
        .environmentObject(Router())
}
