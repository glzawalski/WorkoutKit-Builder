//
//  ZoneAlertSheet.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 16/02/24.
//

import SwiftUI
import WorkoutKit

enum ZoneAlertType {
    case heartRate
    case power
}

struct ZoneAlertSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router

    @Binding var alert: (any WorkoutAlert)?
    @State var type: ZoneAlertType
    @State var zone = Int.zero

    var body: some View {
        VStack {
            HStack {
                Text("Zone")

                TextField("Zone", value: $zone, formatter: NumberFormatter.integer)
                    .keyboardType(.numberPad)
            }

            Button(
                action: {
                    switch type {
                    case .heartRate:
                        alert = HeartRateZoneAlert(zone: zone)
                    case .power:
                        alert = PowerZoneAlert(zone: zone)
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
        .onChange(of: alert as? HeartRateZoneAlert, initial: true) { // TODO: Special modifier?? Generics??
            if let alert = alert as? HeartRateZoneAlert {
                zone = alert.zone
            }
        }
    }
}

#Preview {
    ZoneAlertSheet(alert: .constant(nil), type: .power)
        .environmentObject(Router())
}
