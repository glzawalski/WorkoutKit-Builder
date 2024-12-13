//
//  AlertType.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 05/02/24.
//

import Foundation
import WorkoutKit

enum AlertType: String, CaseIterable {
    case cadenceRange = "Cadence Range"
    case cadenceThreshold = "Cadence Threshold"
    case heartRateRange = "Heart Rate Range"
    case heartRateZone = "Heart Rate Zone"
    case powerRange = "Power Range"
    case powerThreshold = "Power Threshold"
    case powerZone = "Power Zone"
    case speedRange = "Speed Range"
    case speedThreshold = "Speed Threshold"

    public static var supportedCases: [AlertType] {
        return allCases.map { alertType in
            let workoutAlert: (any WorkoutAlert)
            switch alertType {
            case .cadenceRange:
                workoutAlert = CadenceRangeAlert.cadence(1...2)
            case .cadenceThreshold:
                workoutAlert = CadenceThresholdAlert.cadence(1)
            case .heartRateRange:
                workoutAlert = HeartRateRangeAlert.heartRate(1...2)
            case .heartRateZone:
                workoutAlert = HeartRateZoneAlert.heartRate(zone: 1)
            case .powerRange:
                workoutAlert = PowerRangeAlert.power(1...2, unit: .watts)
            case .powerThreshold:
                workoutAlert = PowerThresholdAlert.power(1, unit: .watts)
            case .powerZone:
                workoutAlert = PowerZoneAlert.power(zone: 1)
            case .speedRange:
                workoutAlert = SpeedRangeAlert.speed(1...2, unit: .metersPerSecond)
            case .speedThreshold:
                workoutAlert = SpeedThresholdAlert.speed(1, unit: .metersPerSecond)
            }

            guard CustomWorkout.supportsAlert(workoutAlert, activity: .running, location: .outdoor) else {
                return nil
            }

            return alertType
        }.compactMap { $0 }
    }
}

enum AlertUnit: String {
    case megahertz = "Megahertz"
    case kilohertz = "Kilohertz"
    case hertz = "Hertz"

    static var frequencyCases: [AlertUnit] {
        [.megahertz, .kilohertz, .hertz]
    }

    case kilowatts = "Kilowatts"
    case watts = "Watts"
    case milliwatts = "Milliwatts"

    static var powerCases: [AlertUnit] {
        [.kilowatts, .watts, .milliwatts]
    }

    case metersPerSecond = "Meters per second"
    case kilometersPerHour = "Kilometers per hour"
    case milesPerHour = "Miles per hour"
    case knots = "Knots"

    static var speedCases: [AlertUnit] {
        [.metersPerSecond, .kilometersPerHour, .milesPerHour, .knots]
    }
}

enum AlertMetric: String, CaseIterable {
    case average = "Average"
    case current = "Current"
}
