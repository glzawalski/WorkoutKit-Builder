//
//  AddGoalAlertView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 09/12/24.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct AddGoalAlertView: View {
    let activity: HKWorkoutActivityType
    let location: HKWorkoutSessionLocationType

    @Binding var workoutStep: WorkoutStep

    @State private var selectedGoal: WorkoutGoalOptions = .open
    @State private var selectedGoalValue: Double = 1 // TODO: Ensure its never 0
    @State private var presentGoalValueInput: Bool = false

    @State private var selectedAlert: WorkoutAlertEnum?
    @State private var selectedAlertRangeFrequency: ClosedRange<Measurement<UnitFrequency>> = .init(
        uncheckedBounds: (lower: .init(value: 1, unit: .hertz),
                          upper: .init(value: 2, unit: .hertz))
    )
    @State private var selectedAlertRangePower: ClosedRange<Measurement<UnitPower>> = .init(
        uncheckedBounds: (lower: .init(value: 1, unit: .watts),
                          upper: .init(value: 2, unit: .watts))
    )
    @State private var selectedAlertRangeSpeed: ClosedRange<Measurement<UnitSpeed>> = .init(
        uncheckedBounds: (lower: .init(value: 1, unit: .metersPerSecond),
                          upper: .init(value: 2, unit: .metersPerSecond))
    )
    @State private var selectedAlertZone: Int = 1
    @State private var selectedAlertThresholdFrequency: Measurement<UnitFrequency> = .init(value: 1, unit: .hertz)
    @State private var selectedAlertThresholdPower: Measurement<UnitPower> = .init(value: 1, unit: .watts)
    @State private var selectedAlertThresholdSpeed: Measurement<UnitSpeed> = .init(value: 1, unit: .metersPerSecond)
    @State private var selectedAlertMetric: WorkoutAlertMetric = .average
    @State private var presentAlertInput: Bool = false

    var body: some View {
        let selectedGoalBinding = Binding(get: { selectedGoal },
                                          set: { selectedGoal = $0; workoutStep.goal = $0.goal(with: selectedGoalValue) })
        let selectedAlertBinding = Binding(get: { selectedAlert },
                                           set: { selectedAlert = $0; workoutStep.alert = $0?.alert })
        VStack {
            HStack {
                Text("Add a goal")
                Text("\(selectedGoalValue)")
                    .opacity(selectedGoal == .open ? 0 : 1)
                    .frame(maxWidth: selectedGoal == .open ? 0 : nil)
                    .animation(.default, value: selectedGoal == .open)
                // TODO: Add custom segmented control picker with swappable options and resetting option
                Picker("Add a goal", selection: selectedGoalBinding) {
                    ForEach(activity.supportedGoals(location: location), id: \.self) { goalOptions in
                        Text("\(goalOptions.rawValue)")
                            .tag(goalOptions)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: selectedGoal) { _, newValue in
                    guard newValue != .open else { return }
                    presentGoalValueInput.toggle()
                }
            }

            HStack {
                Text("Add an alert")
                // TODO: Add custom segmented control picker with swappable options
                Picker("Add an alert", selection: selectedAlertBinding) {
                    Text("None")
                        .tag(nil as WorkoutAlertEnum?)
                    ForEach(activity.supportedAlerts(location: location), id: \.self) { alertEnum in
                        Text(alertEnum.alert.description)
                            .tag(alertEnum)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: selectedAlert) { _, newValue in
                    guard newValue != nil else { return }
                    presentAlertInput.toggle()
                }
            }
        }
        .onAppear {
            selectedGoal = workoutStep.goal.enum
            selectedAlert = workoutStep.alert?.enum
        }
        .sheet(isPresented: $presentGoalValueInput) {
            goalValueInput
        }
        .sheet(isPresented: $presentAlertInput) {
            rangeAlertInput
        }
    }

    private var goalValueInput: some View {
        let selectedGoalValueBinding = Binding(get: { selectedGoalValue },
                                               set: { selectedGoalValue = $0; workoutStep.goal = selectedGoal.goal(with: $0) })
        return VStack {
            Text("Goal value:")
            TextField("Goal value:", value: selectedGoalValueBinding, formatter: NumberFormatter())
        }
    }

    private var rangeAlertInput: some View {
        Group {
            switch selectedAlert {
            case .heartRateRange, .cadenceRange, .powerRange, .speedRange:
                rangeAlertValueInput
            case .heartRateZone, .powerZone:
                zoneAlertValueInput
            case .cadenceThreshold, .powerThreshold, .speedThreshold:
                thresholdAlertValueInput
            case nil:
                EmptyView()
            }
        }
    }

    private var rangeAlertValueInput: some View {
        Text("Range input")
    }

    private var zoneAlertValueInput: some View {
        Text("Zone input")
    }

    private var thresholdAlertValueInput: some View {
        let frequencyBinding = Binding(get: { selectedAlertThresholdFrequency },
                                       set: { selectedAlertThresholdFrequency = $0; workoutStep.alert = selectedAlert?.thresholdAlert(with: selectedAlertThresholdFrequency) })
        let powerBinding = Binding(get: { selectedAlertThresholdPower },
                                   set: { selectedAlertThresholdPower = $0; workoutStep.alert = selectedAlert?.thresholdAlert(with: selectedAlertThresholdPower) })
        let speedBinding = Binding(get: { selectedAlertThresholdSpeed },
                                   set: { selectedAlertThresholdSpeed = $0; workoutStep.alert = selectedAlert?.thresholdAlert(with: selectedAlertThresholdSpeed, metric: selectedAlertMetric) })
        return VStack {
            Text("Alert threshold value:")

            TextField("Alert threshold value:", value: frequencyBinding, formatter: NumberFormatter())
                .opacity(selectedAlert == .cadenceThreshold ? 1 : 0)
                .frame(maxWidth: selectedAlert == .cadenceThreshold ? nil : 0, maxHeight: selectedAlert == .cadenceThreshold ? nil : 0)

            TextField("Alert threshold value:", value: powerBinding, formatter: NumberFormatter())
                .opacity(selectedAlert == .powerThreshold ? 1 : 0)
                .frame(maxWidth: selectedAlert == .powerThreshold ? nil : 0, maxHeight: selectedAlert == .powerThreshold ? nil : 0)

            HStack {
                TextField("Alert threshold value:", value: speedBinding, formatter: NumberFormatter())
                    .opacity(selectedAlert == .speedThreshold ? 1 : 0)
                    .frame(maxWidth: selectedAlert == .speedThreshold ? nil : 0, maxHeight: selectedAlert == .speedThreshold ? nil : 0)
                Picker("Alert unit", selection: $selectedAlertMetric) {
                    ForEach(WorkoutAlertMetric.allCases, id: \.self) { metric in
                        Text(metric.description)
                            .tag(metric)
                    }
                }
            }
        }
    }
}

#Preview {
    var workoutStep: WorkoutStep = .init(goal: .open,
                                         alert: nil)

    AddGoalAlertView(
        activity: .americanFootball,
        location: .indoor,
        workoutStep: .init(get: { workoutStep },
                           set: { workoutStep = $0 })
    )
}

enum WorkoutGoalOptions: String, CaseIterable {
    case open = "open"

    case feet = "ft"
    case meters = "m"
    case yards = "yd"
    case kilometers = "km"
    case miles = "mi"

    case seconds = "s"
    case minutes = "min"
    case hours = "h"

    case calories = "cal"
    case kilocalories = "kcal"
    case joules = "j"
    case kilojoules = "kj"
    case kilowattHours = "kWh"

    func goal(with value: Double) -> WorkoutGoal {
        switch self {
        case .open: return .open
        case .feet: return .distance(value, .feet)
        case .meters: return .distance(value, .meters)
        case .yards: return .distance(value, .yards)
        case .kilometers: return .distance(value, .kilometers)
        case .miles: return .distance(value, .miles)
        case .seconds: return .time(value, .seconds)
        case .minutes: return .time(value, .minutes)
        case .hours: return .time(value, .hours)
        case .calories: return .energy(value, .calories)
        case .kilocalories: return .energy(value, .kilocalories)
        case .joules: return .energy(value, .joules)
        case .kilojoules: return .energy(value, .kilojoules)
        case .kilowattHours: return .energy(value, .kilowattHours)
        }
    }
}
