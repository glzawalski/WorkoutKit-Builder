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

// MARK: - Range alerts
extension WorkoutAlertEnum {
    func rangeAlert(with range: ClosedRange<Measurement<UnitFrequency>>) -> (any WorkoutAlert)? {
        switch self {
        case .heartRateRange:
            return HeartRateRangeAlert(target: range)
        case .cadenceRange:
            return CadenceRangeAlert(target: range)
        default:
            return nil
        }
    }

    func rangeAlert(with range: ClosedRange<Measurement<UnitPower>>) -> (any WorkoutAlert)? {
        if case .powerRange = self {
            return PowerRangeAlert(target: range)
        }
        return nil
    }

    func rangeAlert(with range: ClosedRange<Measurement<UnitSpeed>>, metric: WorkoutAlertMetric) -> (any WorkoutAlert)? {
        if case .speedRange = self {
            return SpeedRangeAlert(target: range, metric: metric)
        }
        return nil
    }
}

// MARK: - Zone alerts
extension WorkoutAlertEnum {
    func zoneAlert(with zone: Int) -> (any WorkoutAlert)? {
        switch self {
        case .heartRateZone:
            return HeartRateZoneAlert(zone: zone)
        case .powerZone:
            return PowerZoneAlert(zone: zone)
        default:
            return nil
        }
    }
}

// MARK: - Threshold alerts
extension WorkoutAlertEnum {
    func thresholdAlert(with target: Measurement<UnitFrequency>) -> (any WorkoutAlert)? {
        if case .cadenceThreshold = self {
            return CadenceThresholdAlert(target: target)
        }
        return nil
    }

    func thresholdAlert(with target: Measurement<UnitPower>) -> (any WorkoutAlert)? {
        if case .powerThreshold = self {
            return PowerThresholdAlert(target: target)
        }
        return nil
    }

    func thresholdAlert(value: Double, unit: UnitSpeed, metric: WorkoutAlertMetric) -> (any WorkoutAlert)? {
        if case .speedThreshold = self {
            let target = Measurement(value: value, unit: unit)
            return SpeedThresholdAlert(target: target, metric: metric)
        }
        return nil
    }
}
