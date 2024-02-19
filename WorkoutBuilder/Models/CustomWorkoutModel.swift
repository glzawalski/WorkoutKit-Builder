//
//  CustomWorkout.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 05/02/24.
//

import Foundation
import WorkoutKit
import HealthKit
import SwiftUI

class CustomWorkoutModel: ObservableObject {
    @Published var customWorkouts = [CustomWorkout]()

    @Published var activityType = HKWorkoutActivityType.other
    @Published var locationType = HKWorkoutSessionLocationType.unknown
    @Published var displayName = ""

    @Published var warmupStep: WorkoutStep?
    @Published var intervalBlocks = [IntervalBlock]()
    @Published var cooldownStep: WorkoutStep?

    public var supportedGoals: [WorkoutGoal] {
        return WorkoutGoal.allCases.filter { goal in
            CustomWorkout.supportsGoal(goal, activity: activityType, location: locationType)
        }
    }

    public var supportedAlerts: [WorkoutAlertEnum] {
        return WorkoutAlertEnum.allCases.filter { alertEnum in
            CustomWorkout.supportsAlert(alertEnum.alert, activity: activityType, location: locationType)
        }
    }

    public func makeCustomWorkout() {
        customWorkouts.append(
            CustomWorkout(
                activity: activityType,
                location: locationType,
                displayName: displayName,
                warmup: warmupStep,
                blocks: intervalBlocks,
                cooldown: cooldownStep
            )
        )
    }
}
