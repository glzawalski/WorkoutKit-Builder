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
        case let .distance(value, unit): return "Distance \(value) \(unit.unitSymbol)"
        case let .time(value, unit): return "Time \(value) \(unit.unitSymbol)"
        case let .energy(value, unit): return "Energy \(value) \(unit.unitSymbol)"
        case .open: return "Open goal"
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
