//
//  Enums.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation

enum GoalType: String, CaseIterable {
    case distance = "Distance"
    case energy = "Energy"
    case time = "Time"
    case none = "None"
}

enum Unit: String, CaseIterable {
    // Distance
    case meter = "Meter"
    case inch = "Inch"
    case foot = "Foot"
    case yard = "Yard"
    case mile = "Mile"

    // Energy
    case joule = "Joule"
    case kilocalorie = "Kilocalorie"
    case smallCalorie = "Small calorie"
    case largeCalorie = "Large calorie"

    // Time
    case second = "Second"
    case minute = "Minute"
    case hour = "Hour"
    case day = "Day"

    case none = "None"
}

enum AlertType: String, CaseIterable {
    case averagePace = "Average Pace"
    case currentPace = "Current Pace"
    case currentCadence = "Current Cadence"
    case currentPower = "Current Power"
    case currentHeartRate = "Current Heart Rate"
    case none = "None"
}

enum AlertTarget: String, CaseIterable {
    case value = "Value"
    case range = "Range"
    case zone = "Zone"
    case none = "None"
}

enum StepType: String, CaseIterable {
    case work = "Work"
    case rest = "Rest"
    case none = "None"
}
