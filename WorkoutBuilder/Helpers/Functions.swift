//
//  Functions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 22/08/23.
//

import Foundation
import WorkoutKit
import HealthKit

enum WorkoutStepError: Error {
    case unsupportedGoal
    case unsupportedAlert
}

func createWorkoutStep(
    goalUnit: GoalUnit?,
    goalType: GoalType,
    goalValue: Double,
    alertUnit: AlertUnit?,
    alertMetric: AlertMetric?,
    alertType: AlertType?,
    alertThresholdValue: Double,
    alertRangeMinValue: Double,
    alertRangeMaxValue: Double,
    alertZoneValue: Int,
    activityType: HKWorkoutActivityType,
    activityLocation: HKWorkoutSessionLocationType
) throws -> WorkoutStep {
    var lenght: UnitLength = .meters
    var energy: UnitEnergy = .calories
    var duration: UnitDuration = .seconds
    var goal: WorkoutGoal

    switch goalUnit {
    case .centimeters: lenght = .centimeters
    case .feet: lenght = .feet
    case .kilometers: lenght = .kilometers
    case .meters: lenght = .meters
    case .miles: lenght = .miles
    case .yards: lenght = .yards
    case .calories: energy = .calories
    case .joules: energy = .joules
    case .kilocalories: energy = .kilocalories
    case .kilojoules: energy = .kilojoules
    case .kilowattHours: energy = .kilowattHours
    case .hours: duration = .hours
    case .minutes: duration = .minutes
    case .seconds: duration = .seconds
    case .none: break
    }

    switch goalType {
    case .distance: goal = .distance(goalValue, lenght)
    case .energy: goal = .energy(goalValue, energy)
    case .time: goal = .time(goalValue, duration)
    case .open: goal = .open
    }

    guard CustomWorkout.supportsGoal(goal, activity: activityType, location: activityLocation) else {
        throw WorkoutStepError.unsupportedGoal
    }

    var frequency: UnitFrequency = .hertz
    var power: UnitPower = .watts
    var speed: UnitSpeed = .metersPerSecond
    var metric: WorkoutAlertMetric = .average
    var alert: (any WorkoutAlert)?

    switch alertUnit {
    case .megahertz: frequency = .megahertz
    case .kilohertz: frequency = .kilohertz
    case .hertz: frequency = .hertz
    case .kilowatts: power = .kilowatts
    case .watts: power = .watts
    case .milliwatts: power = .milliwatts
    case .metersPerSecond: speed = .metersPerSecond
    case .kilometersPerHour: speed = .kilometersPerHour
    case .milesPerHour: speed = .milesPerHour
    case .knots: speed = .knots
    case .none: break
    }

    switch alertMetric {
    case .average: metric = .average
    case .current: metric = .current
    case .none: break
    }

    switch alertType {
    case .cadenceRange:
        let min = Measurement(value: alertRangeMinValue, unit: frequency)
        let max = Measurement(value: alertRangeMaxValue, unit: frequency)
        alert = CadenceRangeAlert(target: min...max)

    case .cadenceThreshold:
        alert = CadenceThresholdAlert(target: .init(value: alertThresholdValue, unit: frequency))

    case .heartRateRange:
        let min = Measurement(value: alertRangeMinValue, unit: frequency)
        let max = Measurement(value: alertRangeMaxValue, unit: frequency)
        alert = HeartRateRangeAlert(target: min...max)

    case .heartRateZone:
        alert = HeartRateZoneAlert(zone: alertZoneValue)

    case .powerRange:
        let min = Measurement(value: alertRangeMinValue, unit: power)
        let max = Measurement(value: alertRangeMaxValue, unit: power)
        alert = PowerRangeAlert(target: min...max)

    case .powerThreshold:
        alert = PowerThresholdAlert(target: .init(value: alertThresholdValue, unit: power))

    case .powerZone:
        alert = PowerZoneAlert(zone: alertZoneValue)

    case .speedRange:
        let min = Measurement(value: alertRangeMinValue, unit: speed)
        let max = Measurement(value: alertRangeMaxValue, unit: speed)
        alert = SpeedRangeAlert(target: min...max, metric: metric)

    case .speedThreshold:
        alert = SpeedThresholdAlert(target: .init(value: alertThresholdValue, unit: speed), metric: metric)

    case .none:
        alert = nil
    }

    if let alert {
        guard CustomWorkout.supportsAlert(alert, activity: activityType, location: activityLocation) else {
            throw WorkoutStepError.unsupportedAlert
        }
    }

    return WorkoutStep(goal: goal, alert: alert)
}
