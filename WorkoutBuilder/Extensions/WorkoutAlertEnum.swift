//
//  WorkoutAlertEnum.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 16/12/24.
//

import WorkoutKit

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

    var alert: (any WorkoutAlert)? {
        WorkoutAlertEnum.instanceFactory[self]
    }

    static let instanceFactory: [WorkoutAlertEnum: any WorkoutAlert] = [
        .heartRateRange: HeartRateRangeAlert.heartRate(1...2),
        .heartRateZone: HeartRateZoneAlert.heartRate(zone: 1),
        .cadenceThreshold: CadenceThresholdAlert.cadence(1),
        .cadenceRange: CadenceRangeAlert.cadence(1...2),
        .powerThreshold: PowerThresholdAlert.power(1, unit: .watts),
        .powerRange: PowerRangeAlert.power(1...2, unit: .watts),
        .powerZone: PowerZoneAlert.power(zone: 1),
        .speedThreshold: SpeedThresholdAlert.speed(1, unit: .metersPerSecond),
    ]
}
