//
//  WorkoutGoalExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit
import HealthKit

extension WorkoutGoal: @retroactive CaseIterable {
    public static var allCases: [WorkoutGoal] {
        return [
            .open,
            .distance(1, .meters),
            .energy(1, .calories),
            .time(1,.seconds)
        ]
    }

    var `enum`: WorkoutGoalOptions {
        switch self {
        case .open: return .open
        case .distance(_ , let unitLength) where unitLength == .feet: return .feet
        case .distance(_ , let unitLength) where unitLength == .meters: return .meters
        case .distance(_ , let unitLength) where unitLength == .yards: return .yards
        case .distance(_ , let unitLength) where unitLength == .kilometers: return .kilometers
        case .distance(_ , let unitLength) where unitLength == .miles: return .miles
        case .time(_ , let unitDuration) where unitDuration == .seconds : return .seconds
        case .time(_ , let unitDuration) where unitDuration == .minutes : return .minutes
        case .time(_ , let unitDuration) where unitDuration == .hours : return .hours
        case .energy(_ , let unitEnergy) where unitEnergy == .calories: return .calories
        case .energy(_ , let unitEnergy) where unitEnergy == .kilocalories: return .kilocalories
        case .energy(_ , let unitEnergy) where unitEnergy == .joules : return .joules
        case .energy(_ , let unitEnergy) where unitEnergy == .kilojoules: return .kilojoules
        case .energy(_ , let unitEnergy) where unitEnergy == .kilowattHours: return .kilowattHours
        default: return .open
        }
    }
}
