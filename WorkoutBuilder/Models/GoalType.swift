//
//  GoalType.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import Foundation
import WorkoutKit
import Algorithms

enum GoalType: String, CaseIterable {
    case distance = "Distance"
    case energy = "Energy"
    case time = "Time"
    case open = "Open"

    public static var supportedCases: [GoalType] {
        return allCases.map { goalType in
            let workoutGoal: WorkoutGoal
            switch goalType {
            case .distance:
                workoutGoal = .distance(1, .meters)
            case .energy:
                workoutGoal = .energy(1, .calories)
            case .time:
                workoutGoal = .time(1, .seconds)
            case .open:
                workoutGoal = .open
            }

            guard CustomWorkout.supportsGoal(workoutGoal, activity: .cardioDance, location: .outdoor) else {
                return nil
            }

            return goalType
        }.compactMap { $0 }
    }

    public static var chunks = supportedCases.chunks(ofCount: 2)

    public var defaultUnit: GoalUnit? {
        switch self {
        case .distance:
            return .meters
        case .energy:
            return .calories
        case .time:
            return .seconds
        case .open:
            return nil
        }
    }
}
