//
//  GoalUnit.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import Foundation

enum GoalUnit: String {
    case kilometers = "Kilometers"
    case meters = "Meters"
    case centimeters = "Centimeters"
    case feet = "Feet"
    case yards = "Yards"
    case miles = "Miles"

    static var lengthCases: [GoalUnit] {
        [.kilometers, .meters, .centimeters, .feet, .yards, .miles]
    }

    case kilojoules = "Kilojoules"
    case joules = "Joules"
    case kilocalories = "Kilocalories"
    case calories = "Calories"
    case kilowattHours = "Kilowatt Hours"

    static var energyCases: [GoalUnit] {
        [.kilojoules, .joules, .kilocalories, .calories, .kilowattHours]
    }

    case hours = "Hours"
    case minutes = "Minutes"
    case seconds = "Seconds"

    static var timeCases: [GoalUnit] {
        [.hours, .minutes, .seconds]
    }
}
