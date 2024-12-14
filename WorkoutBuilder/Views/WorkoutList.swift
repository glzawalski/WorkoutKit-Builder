//
//  WorkoutList.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 06/12/24.
//

import SwiftUI
import WorkoutKit

struct WorkoutList: View {
    @State private var workouts: [CustomWorkout] = []
    @State private var isAddingWorkout: Bool = false

    @State private var workoutPlan: WorkoutPlan = .init(.custom(.init(activity: .americanFootball)))
    @State private var isPresentingPlan: Bool = false

    var body: some View {
        VStack {
            List(workouts, id: \.self) { workout in
                Text(workout.displayName ?? "")
                    .onTapGesture {
                        workoutPlan = .init(.custom(workout))
                        isPresentingPlan.toggle()
                    }
            }
            .overlay {
                noWorkoutsView
                    .opacity(workouts.isEmpty ? 1 : 0)
            }
            addWorkoutButton
        }
        .sheet(isPresented: $isAddingWorkout) {
            AddWorkoutView(workouts: $workouts)
        }
        .workoutPreview(workoutPlan, isPresented: $isPresentingPlan)
    }

    var noWorkoutsView: some View {
        ContentUnavailableView(
            "No workouts yet.",
            systemImage: "x.circle",
            description: Text("You have yet to add a workout to your list.")
        )
    }

    var addWorkoutButton: some View {
        Button("Add Workout") {
            isAddingWorkout.toggle()
        }
    }
}

#Preview {
    WorkoutList()
}
