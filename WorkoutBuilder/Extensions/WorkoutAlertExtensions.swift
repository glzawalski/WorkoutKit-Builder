//
//  WorkoutAlertExtensions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/02/24.
//

import Foundation
import WorkoutKit
import HealthKit

protocol WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { get }
}

extension HeartRateZoneAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .heartRateZone }
}

extension HeartRateRangeAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .heartRateRange }
}

extension CadenceThresholdAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .cadenceThreshold }
}

extension CadenceRangeAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .cadenceRange }
}

extension PowerThresholdAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .powerThreshold }
}

extension PowerZoneAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .powerZone }
}

extension PowerRangeAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .powerRange }
}

extension SpeedThresholdAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .speedThreshold }
}

extension SpeedRangeAlert: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { .speedRange }
}

extension WorkoutAlert where Self: WorkoutAlertEnumRepresentable {
    var enumCase: WorkoutAlertEnum? { self.enumCase }
}
