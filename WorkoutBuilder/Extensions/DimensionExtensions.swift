//
//  DimensionExtensions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/02/24.
//

import Foundation

extension Dimension {
    var unitSymbol: String {
        switch self {
        case let length as UnitLength:
            return length.symbol
        case let duration as UnitDuration:
            return duration.symbol
        case let energy as UnitEnergy:
            return energy.symbol
        default:
            return ""
        }
    }
}
