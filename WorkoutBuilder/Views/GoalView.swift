//
//  GoalView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import SwiftUI
import WorkoutKit

struct GoalView: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    @Binding var goal: WorkoutGoal
    @State var unit: Dimension?
    @State var value: Double = .zero
    @State var presentAlert = false

    var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack {
            UnitItem(unit: nil, selected: unit == nil)
                .onTapGesture {
                    goal = .open
                    value = .zero
                    unit = nil
                    router.navigateBack()
                }

            ForEach(model.supportedGoals) { goal in
                ForEach(goal.supportedUnits) { unit in
                    UnitItem(unit: unit, selected: self.unit == unit)
                        .onTapGesture {
                            self.unit = unit
                            presentAlert.toggle()
                        }
                }
            }
        }
        .onChange(of: goal, initial: true) { oldState, newState in
            unit = newState.unit
            value = newState.value
        }
        .navigationTitle("Goal")
        .alert(
            "Goal",
            isPresented: $presentAlert,
            actions: {
                TextField("Value", value: $value, formatter: numberFormatter)
                    .keyboardType(.decimalPad)

                //TODO: Add memory for previous selected goal instead of clearing
                Button(
                    "Cancel",
                    role: .cancel,
                    action: {
                        unit = goal.unit
                        value = goal.value
                    }
                )
                Button(
                    "Add",
                    action: {
                        switch unit {
                        case let length as UnitLength:
                            goal = .distance(value, length)
                        case let duration as UnitDuration:
                            goal = .time(value, duration)
                        case let energy as UnitEnergy:
                            goal = .energy(value, energy)
                        default:
                            goal = .open
                        }
                        router.navigateBack()
                    }
                )
            }
        )
    }
}

struct UnitItem: View {
    let unit: Dimension?
    let selected: Bool

    var body: some View {
        VStack {
            Text("\(unit?.goalDescription ?? "No goal")")
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
    model.locationType = .indoor

    return GoalView(goal: .constant(.open))
        .environmentObject(model)
        .environmentObject(Router())
}
