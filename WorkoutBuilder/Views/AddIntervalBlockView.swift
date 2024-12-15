//
//  AddIntervalBlockView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 09/12/24.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct AddIntervalBlockView: View {
    @Environment(WorkoutBuilderAppState.self) var state

    var body: some View {
        CenteredScrollView {
            VStack {
                ForEach(state.intervalBlocks.indices, id: \.self) { blockIndex in
                    let block = state.intervalBlocks[blockIndex]
                    VStack {
                        Text("Block index: \(blockIndex)")
                        CenteredScrollView(.horizontal) {
                            VStack {
                                ForEach(block.steps.indices, id: \.self) { intervalIndex in
                                    let interval = block.steps[intervalIndex]
                                    Text(interval.purpose.description)
                                    AddGoalAlertView(workoutStep: Bindable(state).intervalBlocks[blockIndex].steps[intervalIndex].step)
                                }
                            }
                        }
                        HStack {
                            Button("Add work step") {
                                state.addNewStepToBlock(blockIndex, purpose: .work)
                            }

                            Button("Add rest step") {
                                state.addNewStepToBlock(blockIndex, purpose: .recovery)
                            }
                        }
                        Text("Repetitions: \(state.intervalBlocks[blockIndex].iterations.description)")
                    }
                }
                Button("Add block") {
                    state.addNewBlock(iterations: 1) // TODO: Ensure its never 0
                }
            }
        }
    }
}
