//
//  HKWorkoutActivityType.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 24/06/23.
//

import Foundation
import HealthKit
import WorkoutKit

extension HKWorkoutActivityType: CaseIterable {
    public static var allCases: [HKWorkoutActivityType] {
        return [
            .americanFootball,
            .archery,
            .australianFootball,
            .badminton,
            .barre,
            .baseball,
            .basketball,
            .bowling,
            .boxing,
            .cardioDance,
            .climbing,
            .cooldown,
            .coreTraining,
            .cricket,
            .crossCountrySkiing,
            .crossTraining,
            .curling,
            .cycling,
            .discSports,
            .downhillSkiing,
            .elliptical,
            .equestrianSports,
            .fencing,
            .fishing,
            .fitnessGaming,
            .flexibility,
            .functionalStrengthTraining,
            .golf,
            .gymnastics,
            .handCycling,
            .handball,
            .highIntensityIntervalTraining,
            .hiking,
            .hockey,
            .hunting,
            .jumpRope,
            .kickboxing,
            .lacrosse,
            .martialArts,
            .mindAndBody,
            .mixedCardio,
            .other,
            .paddleSports,
            .pickleball,
            .pilates,
            .play,
            .preparationAndRecovery,
            .racquetball,
            .rowing,
            .rugby,
            .running,
            .sailing,
            .skatingSports,
            .snowSports,
            .snowboarding,
            .soccer,
            .socialDance,
            .softball,
            .squash,
            .stairClimbing,
            .stairs,
            .stepTraining,
            .surfingSports,
            .swimBikeRun,
            .swimming,
            .tableTennis,
            .taiChi,
            .tennis,
            .trackAndField,
            .traditionalStrengthTraining,
            .transition,
            .underwaterDiving,
            .volleyball,
            .walking,
            .waterFitness,
            .waterPolo,
            .waterSports,
            .wheelchairRunPace,
            .wheelchairWalkPace,
            .wrestling,
            .yoga
        ]
    }

    public static var supportedCases: [HKWorkoutActivityType] {
        return allCases.filter { type in
            CustomWorkout.supportsActivity(type)
        }
    }

    var displayName: String {
        switch self {
        case .americanFootball:
            return "American Football"
        case .archery:
            return "Archery"
        case .australianFootball:
            return "Australian Football"
        case .badminton:
            return "Badminton"
        case .baseball:
            return "Baseball"
        case .basketball:
            return "Basketball"
        case .bowling:
            return "Bowling"
        case .boxing:
            return "Boxing"
        case .climbing:
            return "Climbing"
        case .cricket:
            return "Cricket"
        case .crossTraining:
            return "Cross Training"
        case .curling:
            return "Curling"
        case .cycling:
            return "Cycling"
        case .dance, .danceInspiredTraining:
            return "Dance"
        case .elliptical:
            return "Elliptical"
        case .equestrianSports:
            return "Equestrian Sports"
        case .fencing:
            return "Fencing"
        case .fishing:
            return "Fishing"
        case .functionalStrengthTraining:
            return "Functional Strength Training"
        case .golf:
            return "Golf"
        case .gymnastics:
            return "Gymnastics"
        case .handball:
            return "Handball"
        case .hiking:
            return "Hiking"
        case .hockey:
            return "Hockey"
        case .hunting:
            return "Hunting"
        case .lacrosse:
            return "Lacrosse"
        case .martialArts:
            return "Martial Arts"
        case .mindAndBody:
            return "Mind and Body"
        case .mixedMetabolicCardioTraining:
            return "Mixed Cardio"
        case .paddleSports:
            return "Paddle Sports"
        case .play:
            return "Play"
        case .preparationAndRecovery:
            return "Prep and Recovery"
        case .racquetball:
            return "Racquetball"
        case .rowing:
            return "Rowing"
        case .rugby:
            return "Rugby"
        case .running:
            return "Running"
        case .sailing:
            return "Sailing"
        case .skatingSports:
            return "Skating"
        case .snowSports:
            return "Snow Sports"
        case .soccer:
            return "Soccer"
        case .softball:
            return "Softball"
        case .squash:
            return "Squash"
        case .stairClimbing:
            return "Stair Climbing"
        case .surfingSports:
            return "Surfing"
        case .swimming:
            return "Swimming"
        case .tableTennis:
            return "Table Tennis"
        case .tennis:
            return "Tennis"
        case .trackAndField:
            return "Track and Field"
        case .traditionalStrengthTraining:
            return "Traditional Strength Training"
        case .volleyball:
            return "Volleyball"
        case .walking:
            return "Walking"
        case .waterFitness:
            return "Water Fitness"
        case .waterPolo:
            return "Water Polo"
        case .waterSports:
            return "Water Sports"
        case .wrestling:
            return "Wrestling"
        case .yoga:
            return "Yoga"
        case .barre:
            return "Barre"
        case .coreTraining:
            return "Core Training"
        case .crossCountrySkiing:
            return "Cross Country Skiing"
        case .downhillSkiing:
            return "Downhill Skiing"
        case .flexibility:
            return "Flexibility"
        case .highIntensityIntervalTraining:
            return "High Intensity Interval Training"
        case .jumpRope:
            return "Jump Rope"
        case .kickboxing:
            return "Kickboxing"
        case .pilates:
            return "Pilates"
        case .snowboarding:
            return "Snowboarding"
        case .stairs:
            return "Stairs"
        case .stepTraining:
            return "Step Training"
        case .wheelchairWalkPace:
            return "Wheelchair Roll"
        case .wheelchairRunPace:
            return "Wheelchair Run"
        case .taiChi:
            return "TaiChi"
        case .mixedCardio:
            return "Mixed Cardio"
        case .handCycling:
            return "Hand Cycling"
        case .discSports:
            return "Disc Sports"
        case .fitnessGaming:
            return "Fitness Gaming"
        case .cardioDance:
            return "Cardio Dance"
        case .socialDance:
            return "Social Dance"
        case .pickleball:
            return "Pickleball"
        case .cooldown:
            return "Cooldown"
        case .swimBikeRun:
            return "Swim-Bike-Run"
        case .transition:
            return "Transition"
        case .underwaterDiving:
            return "Underwater Diving"
        case .other:
            return "Other"
        @unknown default:
            return "Other"
        }
    }
}
