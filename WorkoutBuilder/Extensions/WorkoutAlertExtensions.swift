//
//  WorkoutAlertExtensions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/02/24.
//

import Foundation
import WorkoutKit
import HealthKit

extension WorkoutAlert {
    var `enum`: WorkoutAlertEnum? {
        switch self {
        case is HeartRateZoneAlert:
            return .heartRateZone
        case is CadenceThresholdAlert:
            return .cadenceThreshold
        case is CadenceRangeAlert:
            return .cadenceRange
        case is PowerThresholdAlert:
            return .powerThreshold
        case is PowerRangeAlert:
            return .powerRange
        case is PowerZoneAlert:
            return .powerZone
        case is SpeedThresholdAlert:
            return .speedThreshold
        case is SpeedRangeAlert:
            return .speedRange
        default:
            return nil
        }
    }
}

enum WorkoutAlertEnum: String, Hashable, CaseIterable {
    case heartRateRange = "Heart rate range"
    case heartRateZone = "Heart rate zone"
    case cadenceThreshold = "Cadence threshold"
    case cadenceRange = "Cadence range"
    case powerThreshold = "Power threshold"
    case powerRange = "Power range"
    case powerZone = "Power zone"
    case speedThreshold =  "Speed threshold"
    case speedRange = "Speed range"

    var alert: any WorkoutAlert {
        let frequencyMin = Measurement(value: 1, unit: UnitFrequency.hertz)
        let frequencyMax = Measurement(value: 2, unit: UnitFrequency.hertz)
        let powerMin = Measurement(value: 1, unit: UnitPower.watts)
        let powerMax = Measurement(value: 2, unit: UnitPower.watts)
        let speedMin = Measurement(value: 1, unit: UnitSpeed.metersPerSecond)
        let speedMax = Measurement(value: 2, unit: UnitSpeed.metersPerSecond)
        let metric = WorkoutAlertMetric.average

        switch self {
        case .heartRateRange:
            return HeartRateRangeAlert(target: frequencyMin...frequencyMax)
        case .heartRateZone:
            return HeartRateZoneAlert(zone: 1)
        case .cadenceThreshold:
            return CadenceThresholdAlert(target: frequencyMin)
        case .cadenceRange:
            return CadenceRangeAlert(target: frequencyMin...frequencyMax)
        case .powerThreshold:
            return PowerThresholdAlert(target: powerMin)
        case .powerRange:
            return PowerRangeAlert(target: powerMin...powerMax)
        case .powerZone:
            return PowerZoneAlert(zone: 1)
        case .speedThreshold:
            return SpeedThresholdAlert(target: speedMin, metric: metric)
        case .speedRange:
            return SpeedRangeAlert(target: speedMin...speedMax, metric: metric)
        }
    }
}
