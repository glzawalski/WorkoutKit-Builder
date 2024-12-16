//
//  WorkoutAlertMetricExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 14/12/24.
//

import WorkoutKit

extension WorkoutAlertMetric: @retroactive CaseIterable {
    public static var allCases: [WorkoutAlertMetric] {
        [.average, .current]
    }

    var description: String {
        switch self {
        case .average: return "Average"
        case .current: return "Current"
        @unknown default: return ""
        }
    }
}
