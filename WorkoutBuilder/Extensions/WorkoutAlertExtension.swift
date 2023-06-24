//
//  WorkoutAlertExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit

extension WorkoutAlert {
    var description: String {
        var alertString: String

        switch type {
        case .averagePace: alertString = "Average Pace"
        case .currentPace: alertString = "Current Pace"
        case .currentCadence: alertString = "Current Cadence"
        case .currentPower: alertString = "Current Power"
        case .currentHeartRate: alertString = "Current Heart Rate"
        @unknown default: alertString = "No alert"
        }

        switch target {
        case let .target(value): alertString += " with target of \(value)"
        case let .range(min, max): alertString += " within \(min) and \(max)"
        case let .zone(zone): alertString += " in zone \(zone)"
        @unknown default: break
        }

        return alertString
    }
}
