//
//  WorkoutStepView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct WorkoutStepView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var workoutStep: WorkoutStep?
    private var title: String
    private var type: HKWorkoutActivityType
    private var location: HKWorkoutSessionLocationType

    @State private var goalType: GoalType
    @State private var goalUnit: GoalUnit?
    @State private var goalValue: Double = .zero

    @State private var alertType: AlertType?
    @State private var alertUnit: AlertUnit?
    @State private var alertMetric: AlertMetric?
    @State private var alertThresholdValue: Double = .zero
    @State private var alertRangeMinValue: Double = .zero
    @State private var alertRangeMaxValue: Double = .zero
    @State private var alertZoneValue: Int = .zero

    @State private var presentAlert: Bool = false
    @State private var alertText: String = ""

    init(workoutStep: Binding<WorkoutStep?>, title: String, type: HKWorkoutActivityType, location: HKWorkoutSessionLocationType) {
        _workoutStep = workoutStep
        self.title = title
        self.type = type
        self.location = location

        switch workoutStep.wrappedValue?.goal {
        case .open:
            _goalType = .init(initialValue: .open)

        case .distance(let double, let unitLength):
            _goalType = .init(initialValue: .distance)

            switch unitLength {
            case .kilometers: _goalUnit = .init(initialValue: .kilometers)
            case .meters: _goalUnit = .init(initialValue: .meters)
            case .centimeters: _goalUnit = .init(initialValue: .centimeters)
            case .feet: _goalUnit = .init(initialValue: .feet)
            case .yards: _goalUnit = .init(initialValue: .yards)
            case .miles: _goalUnit = .init(initialValue: .miles)
            default: _goalUnit = .init(initialValue: nil)
            }

            goalValue = double

        case .time(let double, let unitDuration):
            _goalType = .init(initialValue: .time)

            switch unitDuration {
            case .hours: _goalUnit = .init(initialValue: .hours)
            case .minutes: _goalUnit = .init(initialValue: .minutes)
            case .seconds: _goalUnit = .init(initialValue: .seconds)
            default: _goalUnit = .init(initialValue: nil)
            }

            goalValue = double

        case .energy(let double, let unitEnergy):
            _goalType = .init(initialValue: .energy)

            switch unitEnergy {
            case .kilojoules: _goalUnit = .init(initialValue: .kilojoules)
            case .joules: _goalUnit = .init(initialValue: .joules)
            case .kilocalories: _goalUnit = .init(initialValue: .kilocalories)
            case .calories: _goalUnit = .init(initialValue: .calories)
            case .kilowattHours: _goalUnit = .init(initialValue: .kilowattHours)
            default: _goalUnit = .init(initialValue: nil)
            }

            goalValue = double

        case .none:
            _goalType = .init(initialValue: .open)
            _goalUnit = .init(initialValue: nil)
            goalValue = .zero

        @unknown default:
            _goalType = .init(initialValue: .open)
            _goalUnit = .init(initialValue: nil)
            goalValue = .zero
        }

        switch workoutStep.wrappedValue?.goal {
        case .distance: _goalType = .init(initialValue: .distance)
        case .time: _goalType = .init(initialValue: .time)
        case .energy: _goalType = .init(initialValue: .energy)
        case .open: _goalType = .init(initialValue: .open)
        case .none: _goalType = .init(initialValue: .open)
        @unknown default: _goalType = .init(initialValue: .open)
        }

        switch workoutStep.wrappedValue?.alert?.metric {
        case .current: _alertMetric = .init(initialValue: .current)
        case .average: _alertMetric = .init(initialValue: .average)
        case nil: _alertMetric = .init(initialValue: .none)
        case .some(_): _alertMetric = .init(initialValue: .none)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                WorkoutGoalSection(
                    type: $goalType,
                    unit: $goalUnit,
                    value: $goalValue
                )

                WorkoutAlertSection(
                    type: $alertType,
                    unit: $alertUnit,
                    metric: $alertMetric,
                    thresholdValue: $alertThresholdValue,
                    rangeMinValue: $alertRangeMinValue,
                    rangeMaxValue: $alertRangeMaxValue,
                    zoneValue: $alertZoneValue
                )
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        do {
                            workoutStep = try createWorkoutStep(
                                goalUnit: goalUnit,
                                goalType: goalType,
                                goalValue: goalValue,
                                alertUnit: alertUnit,
                                alertMetric: alertMetric,
                                alertType: alertType,
                                alertThresholdValue: alertThresholdValue,
                                alertRangeMinValue: alertRangeMinValue,
                                alertRangeMaxValue: alertRangeMaxValue,
                                alertZoneValue: alertZoneValue,
                                activityType: type,
                                activityLocation: location
                            )
                            dismiss()
                        } catch WorkoutStepError.unsupportedAlert {
                            alertText = "Unsupported Alert"
                            presentAlert.toggle()
                        } catch WorkoutStepError.unsupportedGoal {
                            alertText = "Unsupported Goal"
                            presentAlert.toggle()
                        } catch {
                            alertText = "Unsupported Goal or Alert"
                            presentAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .alert(alertText, isPresented: $presentAlert) {
                Button {
                    presentAlert.toggle()
                } label: {
                    Text("OK")
                }
            }
        }
    }
}

#Preview {
    WorkoutStepView(
        workoutStep: .constant(
            WorkoutStep(
                goal: .distance(1, UnitLength(symbol: "M")),
                alert: CadenceThresholdAlert(target: Measurement(value: 1, unit: UnitFrequency(symbol: "Hz")))
            )
        ),
        title: "Add Cooldown",
        type: .other,
        location: .outdoor
    )
}
