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
    static var allCases: [any WorkoutAlert] {
        let frequencyMin = Measurement(value: 1, unit: UnitFrequency.hertz)
        let frequencyMax = Measurement(value: 2, unit: UnitFrequency.hertz)
        let powerMin = Measurement(value: 1, unit: UnitPower.watts)
        let powerMax = Measurement(value: 2, unit: UnitPower.watts)
        let speedMin = Measurement(value: 1, unit: UnitSpeed.metersPerSecond)
        let speedMax = Measurement(value: 2, unit: UnitSpeed.metersPerSecond)
        let metric = WorkoutAlertMetric.average

        return [
            HeartRateRangeAlert(target: frequencyMin...frequencyMax),
            HeartRateZoneAlert(zone: 1),
            CadenceThresholdAlert(target: frequencyMin),
            CadenceRangeAlert(target: frequencyMin...frequencyMax),
            PowerThresholdAlert(target: powerMin),
            PowerRangeAlert(target: powerMin...powerMax),
            PowerZoneAlert(zone: 1),
            SpeedThresholdAlert(target: speedMin, metric: metric),
            SpeedRangeAlert(target: speedMin...speedMax, metric: metric)
        ]
    }

    var description: String {
        switch self {
        case is HeartRateRangeAlert:
            return "Heart rate range"
        case is HeartRateZoneAlert:
            return "Heart rate zone"
        case is CadenceThresholdAlert:
            return "Cadence threshold"
        case is CadenceRangeAlert:
            return "Cadence range"
        case is PowerThresholdAlert:
            return "Power threshold"
        case is PowerRangeAlert:
            return "Power range"
        case is PowerZoneAlert:
            return "Power zone"
        case is SpeedThresholdAlert:
            return "Speed threshold"
        case is SpeedRangeAlert:
            return "Speed range"
        default:
            return ""
        }
    }

    var `enum`: WorkoutAlertEnum? {
        switch self {
        case is HeartRateRangeAlert:
            return .heartRateRange
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

    var supportedUnits: [Dimension] {
        switch self {
        case is HeartRateRangeAlert:
            return UnitFrequency.allCases
        case is HeartRateZoneAlert:
            return []
        case is CadenceThresholdAlert:
            return UnitFrequency.allCases
        case is CadenceRangeAlert:
            return UnitFrequency.allCases
        case is PowerThresholdAlert:
            return UnitPower.allCases
        case is PowerRangeAlert:
            return UnitPower.allCases
        case is PowerZoneAlert:
            return []
        case is SpeedThresholdAlert:
            return UnitSpeed.allCases
        case is SpeedRangeAlert:
            return UnitSpeed.allCases
        default:
            return []
        }
    }
}

extension HeartRateRangeAlert {
    public static var supportedUnits: [UnitFrequency] {
        return UnitFrequency.allCases
    }
}

extension CadenceRangeAlert {
    public static var supportedUnits: [UnitFrequency] {
        return UnitFrequency.allCases
    }
}

enum WorkoutAlertEnum: CaseIterable {
    case heartRateRange
    case heartRateZone
    case cadenceThreshold
    case cadenceRange
    case powerThreshold
    case powerRange
    case powerZone
    case speedThreshold
    case speedRange

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
