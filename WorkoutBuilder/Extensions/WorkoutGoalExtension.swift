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
        case let .distance(quantity, unit): return "Distance: \(quantity) \(unit)"
        case let .time(quantity, unit): return "Time: \(quantity) \(unit)"
        case let .energy(quantity, unit): return "Energy \(quantity) \(unit)"
        case .open: return "No goal"
        @unknown default: return "No goal"
        }
    }
}
