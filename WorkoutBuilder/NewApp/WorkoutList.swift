//
//  WorkoutList.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 06/12/24.
//

import SwiftUI

struct WorkoutList: View {
    @State private var workouts: [Workout] = []
    @State private var isAddingWorkout: Bool = false

    var body: some View {
        VStack {
            List(workouts) { workout in
                Text(workout.name)
            }
            .overlay {
                if workouts.isEmpty { noWorkoutsView }
            }
            addWorkoutButton
        }
        .sheet(isPresented: $isAddingWorkout) {
            AddWorkoutView(workouts: $workouts)
        }
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
