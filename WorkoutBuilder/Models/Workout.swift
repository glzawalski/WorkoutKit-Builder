//
//  Workout.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 06/12/24.
//

import HealthKit
import WorkoutKit

struct Workout: Identifiable {
    let id = UUID()

    var type: HKWorkoutActivityType
    var location: HKWorkoutSessionLocationType
    var name: String
    var warmup: WorkoutStep?
    var blocks: [IntervalBlock]
    var cooldown: WorkoutStep?
}
