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

extension Workout {
    static func fixture() -> [Workout] {
        return [
            Workout(type: .americanFootball,
                    location: .outdoor,
                    name: "American Football",
                    warmup: nil,
                    blocks: [],
                    cooldown: nil),
            Workout(type: .archery,
                    location: .outdoor,
                    name: "Archery",
                    warmup: nil,
                    blocks: [],
                    cooldown: nil),
            Workout(type: .australianFootball,
                    location: .outdoor,
                    name: "Australian Football",
                    warmup: nil,
                    blocks: [],
                    cooldown: nil),
            Workout(type: .badminton,
                    location: .outdoor,
                    name: "Badminton",
                    warmup: nil,
                    blocks: [],
                    cooldown: nil)
        ]
    }
}
