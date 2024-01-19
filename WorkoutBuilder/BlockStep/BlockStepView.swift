//
//  BlockStepView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct BlockStepView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var intervalSteps: [IntervalStep]
    @Binding var selectedStep: Int?
    private var addingNew: Bool
    private var type: HKWorkoutActivityType
    private var location: HKWorkoutSessionLocationType

    @State private var stepType: StepType

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

    init(intervalSteps: Binding<[IntervalStep]>, selectedStep: Binding<Int?>, addingNew: Bool, type: HKWorkoutActivityType, location: HKWorkoutSessionLocationType) {
        _intervalSteps = intervalSteps
        self._selectedStep = selectedStep
        self.addingNew = addingNew
        self.type = type
        self.location = location

        if let step = selectedStep.wrappedValue {
            let intervalStep = intervalSteps[step]

            switch intervalStep.wrappedValue.purpose {
            case .work: _stepType = .init(initialValue: .work)
            case .recovery: _stepType = .init(initialValue: .recovery)
            @unknown default: _stepType = .init(initialValue: .recovery)
            }
            
            switch intervalStep.wrappedValue.step.goal {
            case .distance: _goalType = .init(initialValue: .distance)
            case .time: _goalType = .init(initialValue: .time)
            case .energy: _goalType = .init(initialValue: .energy)
            case .open: _goalType = .init(initialValue: .open)
            @unknown default: _goalType = .init(initialValue: .open)
            }

            switch intervalStep.wrappedValue.step.alert?.metric {
            case .current: _alertMetric = .init(initialValue: .current)
            case .average: _alertMetric = .init(initialValue: .average)
            case nil: _alertMetric = .init(initialValue: .none)
            case .some(_): _alertMetric = .init(initialValue: .none)
            }
        } else {
            _stepType = .init(initialValue: .recovery)
            _goalType = .init(initialValue: .open)
            _alertType = .init(initialValue: .none)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                typePicker

                WorkoutGoalSection(type: $goalType, unit: $goalUnit, value: $goalValue)

                WorkoutAlertSection(type: $alertType, unit: $alertUnit, metric: $alertMetric, thresholdValue: $alertThresholdValue, rangeMinValue: $alertRangeMinValue, rangeMaxValue: $alertRangeMaxValue, zoneValue: $alertZoneValue)
            }
            .navigationTitle(addingNew ? "Add step": "Edit step")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        var purpose: IntervalStep.Purpose = .recovery

                        switch stepType {
                        case .work: purpose = .work
                        case .recovery: purpose = .recovery
                        }

                        do {
                            let newStep = try createWorkoutStep(
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

                            if addingNew {
                                intervalSteps.append(.init(purpose, step: newStep))
                            } else if let selectedStep {
                                intervalSteps.remove(at: selectedStep)
                                intervalSteps.insert(.init(purpose, step: newStep), at: selectedStep)
                            }

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
                        if let selectedStep {
                            intervalSteps.remove(at: selectedStep)
                        }

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

private extension BlockStepView {
    var typePicker: some View {
        Picker("Type", selection: $stepType) {
            ForEach(StepType.allCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item)
            }
        }
    }
}

#Preview {
    BlockStepView(
        intervalSteps: .constant([]),
        selectedStep: .constant(nil),
        addingNew: false,
        type: .other,
        location: .outdoor
    )
}

enum StepType: String, CaseIterable {
    case work = "Work"
    case recovery = "Recovery"
}
