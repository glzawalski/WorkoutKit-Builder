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
    @State private var selectedGoalValue: Double = 0
    @State private var selectedAlert: WorkoutAlertEnum?
    @State private var presentSheet: Bool = false

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
                    ForEach(WorkoutGoalOptions.allCases, id: \.self) { goalOptions in
                        Text("\(goalOptions.rawValue)")
                            .tag(goalOptions)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: selectedGoal) { _, newValue in
                    guard newValue != .open else { return }
                    presentSheet.toggle()
                }
            }

            HStack {
                Text("Add an alert")
                // TODO: Add custom segmented control picker with swappable options
                Picker("Add an alert", selection: selectedAlertBinding) {
                    ForEach(activity.supportedAlerts(location: location), id: \.self) { alertEnum in
                        Text(alertEnum.alert.description)
                            .tag(alertEnum)
                            .onTapGesture {
                                workoutStep.alert = alertEnum.alert
                            }
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .onAppear {
            selectedGoal = workoutStep.goal.enum
            selectedAlert = workoutStep.alert?.enum
        }
        .sheet(isPresented: $presentSheet) {
            modal
        }
    }

    private var modal: some View {
        let selectedGoalValueBinding = Binding(get: { selectedGoalValue },
                                               set: { selectedGoalValue = $0; workoutStep.goal = selectedGoal.goal(with: $0) })
        return TextField("Goal value:", value: selectedGoalValueBinding, formatter: NumberFormatter())
    }
}

#Preview {
    var workoutStep: WorkoutStep = .init(goal: .energy(1, .calories),
                                         alert: .heartRate(zone: 1))

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
