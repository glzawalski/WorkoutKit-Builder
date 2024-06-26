//
//  WorkoutGoalExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit
import Algorithms
import HealthKit

extension WorkoutGoal: CaseIterable, Identifiable {
    public var id: UUID {
        UUID()
    }

    var description: String {
        switch self {
        case .distance: return "Distance"
        case .time: return "Time"
        case .energy: return "Energy"
        case .open: return "No goal"
        @unknown default: return "No goal"
        }
    }

    // Case paths for enum optional associated values?
    var unit: Dimension? {
        switch self {
        case .open: return nil
        case let .distance(_, unitLength): return unitLength
        case let .time(_, unitDuration): return unitDuration
        case let .energy(_, unitEnergy): return unitEnergy
        @unknown default: return nil
        }
    }

    // Case paths for enum optional associated values?
    var value: Double {
        switch self {
        case .open: return .zero
        case let .distance(double, _), let .time(double, _), let .energy(double, _): return double
        @unknown default: return .zero
        }
    }

    public static var allCases: [WorkoutGoal] {
        return [
            .open,
            .distance(1, .meters),
            .energy(1, .calories),
            .time(1,.seconds)
        ]
    }

    var supportedUnits: [Dimension] {
        switch self {
        case .distance: return [UnitLength.feet, UnitLength.meters, UnitLength.yards, UnitLength.kilometers, UnitLength.miles]
        case .time: return [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours]
        case .energy: return [UnitEnergy.calories, UnitEnergy.kilocalories, UnitEnergy.joules, UnitEnergy.kilojoules, UnitEnergy.kilowattHours]
        case .open: return []
        @unknown default: return []
        }
    }
}
