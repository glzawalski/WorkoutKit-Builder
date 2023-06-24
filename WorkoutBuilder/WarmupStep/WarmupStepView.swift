//
//  WarmupStepView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 20/06/23.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct WarmupStepView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var warmupStep: WarmupStep?
    private var title: String

    @State private var goalType: GoalType
    @State private var goalUnit: Unit = .none
    @State private var goalValue: Double = .zero

    @State private var alertType: AlertType
    @State private var alertTarget: AlertTarget = .value
    @State private var alertUnit: Unit = .none
    @State private var alertTargetValue: Double = .zero
    @State private var alertRangeMinValue: Double = .zero
    @State private var alertRangeMaxValue: Double = .zero
    @State private var alertZoneValue: Int = .zero

    init(warmupStep: Binding<WarmupStep?> = .constant(nil), title: String) {
        _warmupStep = warmupStep
        self.title = title

        switch warmupStep.wrappedValue?.goal {
        case .distance: _goalType = .init(initialValue: .distance)
        case .time: _goalType = .init(initialValue: .time)
        case .energy: _goalType = .init(initialValue: .energy)
        case nil: _goalType = .init(initialValue: .none)
        case .some(_): _goalType = .init(initialValue: .none)
        }

        switch warmupStep.wrappedValue?.alert?.type {
        case .averagePace: _alertType = .init(initialValue: .averagePace)
        case .currentPace: _alertType = .init(initialValue: .currentPace)
        case .currentCadence: _alertType = .init(initialValue: .currentCadence)
        case .currentPower: _alertType = .init(initialValue: .currentPower)
        case .currentHeartRate: _alertType = .init(initialValue: .currentHeartRate)
        case nil: _alertType = .init(initialValue: .none)
        case .some(_): _alertType = .init(initialValue: .none)
        }

        switch warmupStep.wrappedValue?.alert?.target {
        case .target: _alertTarget = .init(initialValue: .value)
        case .range: _alertTarget = .init(initialValue: .range)
        case .zone: _alertTarget = .init(initialValue: .zone)
        case nil: _alertTarget = .init(initialValue: .none)
        case .some(_): _alertTarget = .init(initialValue: .none)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                goalSection
                
                alertSection
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        warmupStep = createWarmupStep()
                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        warmupStep = nil
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

private extension WarmupStepView {
    var goalSection: some View {
        Section("Goal") {
            goalTypePicker

            optionalGoalUnitPicker

            optionalGoalValue
        }
    }

    var goalTypePicker: some View {
        Picker("Type", selection: $goalType) {
            ForEach(GoalType.allCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item)
            }
        }
    }

    var optionalGoalUnitPicker: some View {
        Group {
            if case .none = goalType {
                EmptyView()
            } else {
                Picker("Unit", selection: $goalUnit) {
                    ForEach(Unit.allCases, id: \.self) { item in
                        Text("\(item.rawValue)")
                            .tag(item)
                    }
                }
            }
        }
    }

    var optionalGoalValue: some View {
        Group {
            if case .none = goalUnit {
                EmptyView()
            } else {
                HStack {
                    Text("Value")
                    TextField("Goal Value", value: $goalValue, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    var alertSection: some View {
        Section("Alert") {
            alertTypePicker

            optionalAlertTargetPicker
        }
    }

    var alertTypePicker: some View {
        Picker("Type", selection: $alertType) {
            ForEach(AlertType.allCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item)
            }
        }
    }

    var optionalAlertTargetPicker: some View {
        Group {
            if case .none = alertType {
                EmptyView()
            } else {
                Picker("Target", selection: $alertTarget) {
                    ForEach(AlertTarget.allCases, id: \.self) { item in
                        Text("\(item.rawValue)")
                            .tag(item)
                    }
                }

                switch alertTarget {
                case .value: alertTargetValueUnitPickerAndValue
                case .range: alertTargetRangeUnitPickerAndValues
                case .zone: alertRangeValue
                case .none: EmptyView()
                }
            }
        }
    }

    var alertTargetValueUnitPickerAndValue: some View {
        Group {
            Picker("Unit", selection: $alertUnit) {
                ForEach(Unit.allCases, id: \.self) { item in
                    Text("\(item.rawValue)")
                        .tag(item)
                }
            }

            if case .none = alertUnit {
                EmptyView()
            } else {
                HStack {
                    Text("Target Value")
                    TextField("Alert Target Value", value: $alertTargetValue, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    var alertTargetRangeUnitPickerAndValues: some View {
        Group {
            Picker("Unit", selection: $alertUnit) {
                ForEach(Unit.allCases, id: \.self) { item in
                    Text("\(item.rawValue)")
                        .tag(item)
                }
            }

            if case .none = alertUnit {
                EmptyView()
            } else {
                HStack {
                    Text("Min Value")
                    TextField("Alert Range Min Value", value: $alertRangeMinValue, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Max Value")
                    TextField("Alert Range Max Value", value: $alertRangeMaxValue, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    var alertRangeValue: some View {
        HStack {
            Text("Zone Value")
            TextField("Alert Zone Value", value: $alertZoneValue, formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
        }
    }

    func createWarmupStep() -> WarmupStep? {
        var goalHKUnit: HKUnit?
        var goal: WorkoutGoal?

        switch goalUnit {
        case .meter: goalHKUnit = .meter()
        case .inch: goalHKUnit = .inch()
        case .foot: goalHKUnit = .foot()
        case .yard: goalHKUnit = .yard()
        case .mile: goalHKUnit = .mile()
        case .joule: goalHKUnit = .joule()
        case .kilocalorie: goalHKUnit = .kilocalorie()
        case .smallCalorie: goalHKUnit = .smallCalorie()
        case .largeCalorie: goalHKUnit = .largeCalorie()
        case .second: goalHKUnit = .second()
        case .minute: goalHKUnit = .minute()
        case .hour: goalHKUnit = .hour()
        case .day: goalHKUnit = .day()
        case .none: goalHKUnit = nil
        }

        if let goalHKUnit {
            let goalQuantity: HKQuantity = .init(unit: goalHKUnit, doubleValue: goalValue)

            switch goalType {
            case .distance: goal = .distance(goalQuantity)
            case .energy: goal = .energy(goalQuantity)
            case .time: goal = .time(goalQuantity)
            case .none: goal = nil
            }
        }

        var alertHKUnit: HKUnit?
        var alertTargetType: WorkoutTargetType?
        var alert: WorkoutAlert?

        switch alertUnit {
        case .meter: alertHKUnit = .meter()
        case .inch: alertHKUnit = .inch()
        case .foot: alertHKUnit = .foot()
        case .yard: alertHKUnit = .yard()
        case .mile: alertHKUnit = .mile()
        case .joule: alertHKUnit = .joule()
        case .kilocalorie: alertHKUnit = .kilocalorie()
        case .smallCalorie: alertHKUnit = .smallCalorie()
        case .largeCalorie: alertHKUnit = .largeCalorie()
        case .second: alertHKUnit = .second()
        case .minute: alertHKUnit = .minute()
        case .hour: alertHKUnit = .hour()
        case .day: alertHKUnit = .day()
        case .none: alertHKUnit = nil
        }

        switch alertTarget {
        case .value, .range:
            if let alertHKUnit {
                if case .value = alertTarget {
                    alertTargetType = .target(value: .init(unit: alertHKUnit, doubleValue: alertTargetValue))
                }

                if case .range = alertTarget {
                    alertTargetType = .range(min: .init(unit: alertHKUnit, doubleValue: alertRangeMinValue), max: .init(unit: alertHKUnit, doubleValue: alertRangeMaxValue))
                }
            }

        case .zone: alertTargetType = .zone(zone: alertZoneValue)
        case .none: alertTargetType = nil
        }

        if let alertTargetType {
            switch alertType {
            case .averagePace: alert = .init(type: .averagePace, target: alertTargetType)
            case .currentPace: alert = .init(type: .currentPace, target: alertTargetType)
            case .currentCadence: alert = .init(type: .currentCadence, target: alertTargetType)
            case .currentPower: alert = .init(type: .currentPower, target: alertTargetType)
            case .currentHeartRate: alert = .init(type: .currentHeartRate, target: alertTargetType)
            case .none: alert = nil
            }
        }

        return WarmupStep(goal: goal, alert: alert)
    }
}

#Preview {
    WarmupStepView(
        warmupStep: .constant(
            WarmupStep(
                goal: .distance(.init(unit: .meter(), doubleValue: 1)),
                alert: .init(type: .averagePace, target: .target(value: .init(unit: .meter(), doubleValue: 1)))
            )
        ),
        title: "Add Warmup"
    )
}
