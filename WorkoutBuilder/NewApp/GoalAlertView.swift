//
//  GoalAlertView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 06/12/24.
//

import SwiftUI

struct GoalAlertView: View {
    @State var value: String = ""
    @State var type: GoalType = .open
    @State var unit: GoalUnit?

    var body: some View {
        VStack {
            typePicker

            unitPicker

            valueInput
        }
    }

    var typePicker: some View {
        Picker("Type", selection: $type) {
            ForEach(GoalType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
    }

    var unitPicker: some View {
        Picker("Unit", selection: $unit) {
            switch type {
            case .distance:
                ForEach(GoalUnit.lengthCases, id: \.self) { unit in
                    Text(unit.rawValue)
                        .tag(unit)
                }
            case .energy:
                ForEach(GoalUnit.energyCases, id: \.self) { unit in
                    Text(unit.rawValue)
                        .tag(unit)
                }
            case .time:
                ForEach(GoalUnit.timeCases, id: \.self) { unit in
                    Text(unit.rawValue)
                        .tag(unit)
                }
            case .open:
                EmptyView()
            }
        }
        .pickerStyle(.segmented)
    }

    var valueInput: some View {
        // TODO: Swap for numbers only input field
        TextField("Enter value", text: $value)
    }
}

#Preview {
    GoalAlertView()
}
