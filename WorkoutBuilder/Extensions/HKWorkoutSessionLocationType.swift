//
//  HKWorkoutSessionLocationType.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 24/06/23.
//

import Foundation
import HealthKit

extension HKWorkoutSessionLocationType: @retroactive CaseIterable {
    public static var allCases: [HKWorkoutSessionLocationType] {
        return [.indoor, .outdoor]
    }

    var displayName: String {
        switch self {
        case .indoor: return "Indoor"
        case .outdoor: return "Outdoor"
        case .unknown: return "Unknown"
        @unknown default: return "Unknown"
        }
    }
}
