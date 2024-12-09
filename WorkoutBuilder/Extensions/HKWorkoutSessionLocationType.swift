//
//  HKWorkoutSessionLocationType.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 24/06/23.
//

import Foundation
import HealthKit

extension HKWorkoutSessionLocationType: CaseIterable {
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

extension HKWorkoutSessionLocationType {
    var displayImage: String {
        switch self {
        case .indoor: return "house"
        case .outdoor: return "sun.horizon"
        case .unknown: return "questionmark.circle"
        @unknown default: return "questionmark.circle"
        }
    }
}
