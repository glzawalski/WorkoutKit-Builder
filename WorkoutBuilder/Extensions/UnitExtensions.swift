//
//  UnitExtensions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 15/02/24.
//

import Foundation

extension UnitFrequency {
    public static var allCases: [UnitFrequency] {
        return [.hertz, .kilohertz, .megahertz]
    }
}

extension UnitPower {
    public static var allCases: [UnitPower] {
        return [.watts, .kilowatts, .megawatts]
    }
}

extension UnitSpeed {
    public static var allCases: [UnitSpeed] {
        return [.metersPerSecond, .kilometersPerHour, .milesPerHour]
    }
}

extension UnitLength {
    public static var allCases: [UnitLength] {
        return [.feet, .meters, .yards, .kilometers, .miles]
    }
}

extension UnitDuration {
    public static var allCases: [UnitDuration] {
        return [.seconds, .minutes, .hours]
    }
}

extension UnitEnergy {
    public static var allCases: [UnitEnergy] {
        return [.calories, .kilocalories, .joules, .kilojoules, .kilowattHours]
    }
}
