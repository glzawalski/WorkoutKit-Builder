//
//  GoalSelector.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/12/24.
//

import SwiftUI
import WorkoutKit

struct GoalSelector: View {
    @Environment(WorkoutBuilderAppState.self) var state
    @Binding var workoutStep: WorkoutStep

    @State private var goal: WorkoutGoalOptions = .open
    @State private var value: Double = 1 // TODO: Ensure its never 0
    @State private var presentValueInput: Bool = false

    var body: some View {
        let goalBinding = Binding(get: { goal },
                                  set: { goal = $0; workoutStep.goal = createGoal() })

        HStack {
            Text("Add a goal")

            Text("\(value)")
                .opacity(goal == .open ? 0 : 1)
                .frame(maxWidth: goal == .open ? 0 : nil)
                .animation(.default, value: goal == .open)

            // TODO: Add custom segmented control picker with swappable options and resetting option
            Picker("Add a goal", selection: goalBinding) {
                ForEach(state.supportedGoals, id: \.self) { goalOptions in
                    Text("\(goalOptions.rawValue)")
                        .tag(goalOptions)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: goal) { _, newValue in
                guard newValue != .open else { return }
                presentValueInput.toggle()
            }
        }
        .onAppear {
            goal = workoutStep.goal.enum
        }
        .sheet(isPresented: $presentValueInput) {
            goalValueInput
        }
    }

    private var goalValueInput: some View {
        let valueBinding = Binding(get: { value },
                                   set: { value = $0; workoutStep.goal = createGoal() })
        return VStack {
            Text("Goal value:")
            TextField("Goal value:", value: valueBinding, formatter: NumberFormatter())
        }
    }
}

// MARK: - WorkoutAlert
private extension GoalSelector {
    func createGoal() -> WorkoutGoal {
        switch goal {
        case .open:
            return .open

        case .feet:
            return .distance(value, .feet)
        case .meters:
            return .distance(value, .meters)
        case .yards:
            return .distance(value, .yards)
        case .kilometers:
            return .distance(value, .kilometers)
        case .miles:
            return .distance(value, .miles)

        case .seconds:
            return .time(value, .seconds)
        case .minutes:
            return .time(value, .minutes)
        case .hours:
            return .time(value, .hours)

        case .calories:
            return .energy(value, .calories)
        case .kilocalories:
            return .energy(value, .kilocalories)
        case .joules:
            return .energy(value, .joules)
        case .kilojoules:
            return .energy(value, .kilojoules)
        case .kilowattHours:
            return .energy(value, .kilowattHours)
        }
    }
}
