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

    @State private var selectedGoal: WorkoutGoalOptions = .open
    @State private var selectedGoalValue: Double = 1 // TODO: Ensure its never 0
    @State private var presentGoalValueInput: Bool = false
    
    var body: some View {
        let selectedGoalBinding = Binding(get: { selectedGoal },
                                          set: { selectedGoal = $0; workoutStep.goal = $0.goal(with: selectedGoalValue) })

        HStack {
            Text("Add a goal")
            Text("\(selectedGoalValue)")
                .opacity(selectedGoal == .open ? 0 : 1)
                .frame(maxWidth: selectedGoal == .open ? 0 : nil)
                .animation(.default, value: selectedGoal == .open)
            // TODO: Add custom segmented control picker with swappable options and resetting option
            Picker("Add a goal", selection: selectedGoalBinding) {
                ForEach(state.supportedGoals, id: \.self) { goalOptions in
                    Text("\(goalOptions.rawValue)")
                        .tag(goalOptions)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: selectedGoal) { _, newValue in
                guard newValue != .open else { return }
                presentGoalValueInput.toggle()
            }
        }
        .onAppear {
            selectedGoal = workoutStep.goal.enum
        }
        .sheet(isPresented: $presentGoalValueInput) {
            goalValueInput
        }
    }

    private var goalValueInput: some View {
        let selectedGoalValueBinding = Binding(get: { selectedGoalValue },
                                               set: { selectedGoalValue = $0; workoutStep.goal = selectedGoal.goal(with: $0) })
        return VStack {
            Text("Goal value:")
            TextField("Goal value:", value: selectedGoalValueBinding, formatter: NumberFormatter())
        }
    }
}
