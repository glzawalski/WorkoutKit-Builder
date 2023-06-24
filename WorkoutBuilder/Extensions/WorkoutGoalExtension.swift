//
//  WorkoutGoalExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit

extension WorkoutGoal {
    var description: String {
        switch self {
        case let .distance(quantity): return "Distance: \(quantity)"
        case let .time(quantity): return "Time: \(quantity)"
        case let .energy(quantity): return "Energy \(quantity)"
        @unknown default: return "No goal"
        }
    }
}
