//
//  WorkoutList.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 06/12/24.
//

import SwiftUI
import WorkoutKit

struct WorkoutList: View {
    @Environment(WorkoutBuilderAppState.self) private var state

    @State private var isAddingWorkout: Bool = false
    @State private var isPresentingPlan: Bool = false

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(state.workouts.indices, id: \.self) { index in
                        Text(state.workouts[index].displayName ?? "")
                            .onTapGesture {
                                state.selectedWorkoutIndex = index
                                state.createPlan()
                                isPresentingPlan.toggle()
                            }
                    }
                } footer: {
                    addWorkoutButton
                }
            }
        }
        .overlay {
            noWorkoutsView
                .opacity(state.workouts.isEmpty ? 1 : 0)
        }
        .sheet(isPresented: $isAddingWorkout) {
            AddWorkoutView()
        }
        .workoutPreview(state.workoutPlan, isPresented: $isPresentingPlan)
    }

    var noWorkoutsView: some View {
        ContentUnavailableView(
            "No workouts yet",
            systemImage: "x.circle",
            description: Text("You have yet to add a workout to your list\nTap to add a workout")
        )
        .background(Color.white)
        .onTapGesture {
            isAddingWorkout.toggle()
        }
    }

    var addWorkoutButton: some View {
        Button("Add Workout") {
            state.resetAddWorkoutProperties()
            isAddingWorkout.toggle()
        }
    }
}

#Preview {
    WorkoutList()
        .environment(WorkoutBuilderAppState())
}
