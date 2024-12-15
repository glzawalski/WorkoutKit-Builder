//
//  WorkoutBuilderAppState.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 14/12/24.
//

import Observation
import WorkoutKit
import HealthKit

@Observable
class WorkoutBuilderAppState {
    var workoutPlan: WorkoutPlan = .init(.custom(.init(activity: .other)))
    var selectedWorkoutIndex: Int = 0
    var workouts: [CustomWorkout] = []
    var activity: HKWorkoutActivityType?
    var location: HKWorkoutSessionLocationType = .indoor
    var displayName: String = "My Workout"
    var hasWarmup: Bool = false
    var warmup: WorkoutStep = .init()
    var intervalBlocks: [IntervalBlock] = []
    var hasCooldown: Bool = false
    var cooldown: WorkoutStep = .init()
}

// MARK: - Workout plans
extension WorkoutBuilderAppState {
    func createPlan() {
        workoutPlan = .init(.custom(workouts[selectedWorkoutIndex]))
    }
}

// MARK: - Workouts
extension WorkoutBuilderAppState {
    func addWorkout() {
        guard let activity else { return }
        workouts.append(.init(activity: activity,
                              location: location,
                              displayName: displayName,
                              warmup: hasWarmup ? warmup : nil,
                              blocks: intervalBlocks,
                              cooldown: hasCooldown ? cooldown : nil))
    }

    func resetAddWorkoutProperties() {
        activity = nil
        location = .indoor
        displayName = "My Workout"
        hasWarmup = false
        warmup = .init()
        intervalBlocks = []
        hasCooldown = false
        cooldown = .init()
    }
}

// MARK: - Goals
extension WorkoutBuilderAppState {
    var supportedGoals: [WorkoutGoalOptions] {
        activity?.supportedGoals(location: location) ?? []
    }
}

// MARK: - Alerts
extension WorkoutBuilderAppState {
    var supportedAlerts: [WorkoutAlertEnum] {
        activity?.supportedAlerts(location: location) ?? []
    }
}

// MARK: - Interval blocks
extension WorkoutBuilderAppState {
    func addNewBlock(iterations: Int) {
        intervalBlocks.append(.init(steps: [], iterations: iterations))
    }
}

// MARK: - Steps
extension WorkoutBuilderAppState {
//    var selectedStep: WorkoutStep = warmup

    func addNewStepToBlock(_ index: Int, purpose: IntervalStep.Purpose) {
        intervalBlocks[index].steps.append(.init(purpose))
    }
}
