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

    var goal: WorkoutGoal {
        WorkoutGoalOptions.instanceFactory[self] ?? .open
    }

    static let instanceFactory: [WorkoutGoalOptions: WorkoutGoal] = [
        .open: .open,
        .feet: .distance(1, .feet),
        .meters: .distance(1, .meters),
        .yards: .distance(1, .yards),
        .kilometers: .distance(1, .kilometers),
        .miles: .distance(1, .miles),
        .seconds: .time(1, .seconds),
        .minutes: .time(1, .minutes),
        .hours: .time(1, .hours),
        .calories: .energy(1, .calories),
        .kilocalories: .energy(1, .kilocalories),
        .joules: .energy(1, .joules),
        .kilojoules: .energy(1, .kilojoules),
        .kilowattHours: .energy(1, .kilowattHours)
    ]
}
