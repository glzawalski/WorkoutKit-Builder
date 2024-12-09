//
//  GoalUnit.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import Foundation

enum GoalUnit: String {
    case meters = "Meters"
    case kilometers = "Kilometers"
    case yards = "Yards"
    case miles = "Miles"

    static var lengthCases: [GoalUnit] {
        [.meters, .kilometers, .yards, .miles]
    }

    case calories = "Calories"
    case kilocalories = "Kilocalories"

    static var energyCases: [GoalUnit] {
        [.calories, .kilocalories]
    }

    case seconds = "Seconds"
    case minutes = "Minutes"
    case hours = "Hours"

    static var timeCases: [GoalUnit] {
        [.seconds, .minutes, .hours]
    }
}
