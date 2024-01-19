//
//  IntervalBlockView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct IntervalBlockView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var intervalBlocks: [IntervalBlock]
    @Binding var selectedBlock: Int?
    private var addingNew: Bool
    private var type: HKWorkoutActivityType
    private var location: HKWorkoutSessionLocationType

    @State private var steps: [IntervalStep]
    @State private var iterations: Int

    @State private var selectedStep: Int?
    @State private var addStep: Bool = false
    @State private var editStep: Bool = false

    init(intervalBlocks: Binding<[IntervalBlock]>, selectedBlock: Binding<Int?>, addingNew: Bool, type: HKWorkoutActivityType, location: HKWorkoutSessionLocationType) {
        _intervalBlocks = intervalBlocks
        self._selectedBlock = selectedBlock
        self.addingNew = addingNew
        self.type = type
        self.location = location

        if let block = selectedBlock.wrappedValue {
            let intervalBlock = intervalBlocks[block]

            _steps = State(initialValue: intervalBlock.wrappedValue.steps)
            _iterations = State(initialValue: intervalBlock.wrappedValue.iterations)
        } else {
            _steps = State(initialValue: [])
            _iterations = State(initialValue: .zero)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                List {
                    ForEach(0..<steps.count, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(steps[index].purpose.description)")

                                HStack {
                                    Image(systemName: "checkmark.square")
                                    Text(": \(steps[index].step.goal.description)")
                                }

                                HStack {
                                    Image(systemName: "bell.circle")
                                    Text(": \(steps[index].step.alert.debugDescription)")
                                }
                            }

                            Spacer()

                            Image(systemName: "pencil.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    selectedStep = index
                                    editStep.toggle()
                                }
                        }
                    }
                }

                Button("Add Step") {
                    addStep.toggle()
                }

                HStack {
                    Text("Iterations")
                    TextField("Iterations", value: $iterations, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }
            }
            .sheet(isPresented: $addStep) {
                BlockStepView(
                    intervalSteps: $steps,
                    selectedStep: $selectedStep,
                    addingNew: true,
                    type: type,
                    location: location
                )
            }
            .sheet(isPresented: $editStep) {
                BlockStepView(
                    intervalSteps: $steps,
                    selectedStep: $selectedStep,
                    addingNew: false,
                    type: type,
                    location: location
                )
            }
            .navigationTitle(addingNew ? "Add New Block" : "Edit Block")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if let newBlock = createIntervalBlock() {
                            if addingNew {
                                intervalBlocks.append(newBlock)
                            } else if let selectedBlock {
                                intervalBlocks[selectedBlock] = newBlock
                            }
                        } else {
                            if let selectedBlock {
                                intervalBlocks.remove(at: selectedBlock)
                            }
                        }

                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }

                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        if let selectedBlock {
                            intervalBlocks.remove(at: selectedBlock)
                        }

                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

private extension IntervalBlockView {
    func createIntervalBlock() -> IntervalBlock? {
        return IntervalBlock(steps: steps, iterations: iterations)
    }
}

#Preview {
    IntervalBlockView(
        intervalBlocks: .constant(
            [
                IntervalBlock(
                    steps: [
                        IntervalStep( .work, goal: .open, alert: nil),
                        IntervalStep( .work, goal: .open, alert: nil),
                        IntervalStep( .recovery, goal: .open, alert: nil),
                    ],
                    iterations: 3
                ),
                IntervalBlock(
                    steps: [
                        IntervalStep( .work, goal: .open, alert: nil),
                        IntervalStep( .recovery, goal: .open, alert: nil),
                    ],
                    iterations: 5
                ),
            ]
        ),
        selectedBlock: .constant(0),
        addingNew: true,
        type: .other,
        location: .unknown
    )
}
