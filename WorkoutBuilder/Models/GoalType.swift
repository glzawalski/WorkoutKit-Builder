//
//  GoalType.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import Foundation
import WorkoutKit

enum WorkoutGoalOptions: String, CaseIterable {
    case open = "open"

    case feet = "ft"
    case meters = "m"
    case yards = "yd"
    case kilometers = "km"
    case miles = "mi"

    case seconds = "s"
    case minutes = "min"
    case hours = "h"

    case calories = "cal"
    case kilocalories = "kcal"
    case joules = "j"
    case kilojoules = "kj"
    case kilowattHours = "kWh"

    func goal(with value: Double) -> WorkoutGoal {
        switch self {
        case .open: return .open
        case .feet: return .distance(value, .feet)
        case .meters: return .distance(value, .meters)
        case .yards: return .distance(value, .yards)
        case .kilometers: return .distance(value, .kilometers)
        case .miles: return .distance(value, .miles)
        case .seconds: return .time(value, .seconds)
        case .minutes: return .time(value, .minutes)
        case .hours: return .time(value, .hours)
        case .calories: return .energy(value, .calories)
        case .kilocalories: return .energy(value, .kilocalories)
        case .joules: return .energy(value, .joules)
        case .kilojoules: return .energy(value, .kilojoules)
        case .kilowattHours: return .energy(value, .kilowattHours)
        }
    }
}
