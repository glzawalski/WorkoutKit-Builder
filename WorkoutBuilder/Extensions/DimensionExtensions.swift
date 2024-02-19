//
//  DimensionExtensions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/02/24.
//

import Foundation

extension Dimension: Identifiable {
    var goalDescription: String {
        switch self {
        case let length as UnitLength:
            return "Distance in \(length.symbol)"
        case let duration as UnitDuration:
            return "Duration in \(duration.symbol)"
        case let energy as UnitEnergy:
            return "Energy in \(energy.symbol)"
        default:
            return "No goal"
        }
    }
}
