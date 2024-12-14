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
    @State var selectedType: HKWorkoutActivityType
    @State var selectedLocation: HKWorkoutSessionLocationType
    @Binding var intervalBlocks: [IntervalBlock]

    @State private var hasSelectedInterval: Bool = false
    @State private var selectedBlock: Int?
    @State private var selectedInterval: Int?

    var body: some View {
        CenteredScrollView {
            VStack {
                ForEach(intervalBlocks.indices, id: \.self) { blockIndex in
                    VStack {
                        Text("Block index: \(blockIndex)")
                        CenteredScrollView(.horizontal) {
                            VStack {
                                ForEach(intervalBlocks[blockIndex].steps.indices, id: \.self) { intervalIndex in
                                    Text(intervalBlocks[blockIndex].steps[intervalIndex].purpose.description)
                                    AddGoalAlertView(
                                        activity: selectedType,
                                        location: selectedLocation,
                                        workoutStep: $intervalBlocks[blockIndex].steps[intervalIndex].step
                                    )
                                }
                            }
                        }
                        HStack {
                            Button("Add work step") {
                                intervalBlocks[blockIndex].steps.append(.init(.work))
                            }

                            Button("Add rest step") {
                                intervalBlocks[blockIndex].steps.append(.init(.recovery))
                            }
                        }
                        Text("Repetitions: \(intervalBlocks[blockIndex].iterations.description)")
                    }
                }
                Button("Add block") {
                    intervalBlocks.append(.init(steps: [], iterations: Int.random(in: 1...10)))
                }
            }
        }
        .navigationDestination(isPresented: $hasSelectedInterval) {
            if let selectedBlock, let selectedInterval {
                AddGoalAlertView(
                    activity: selectedType,
                    location: selectedLocation,
                    workoutStep: $intervalBlocks[selectedBlock].steps[selectedInterval].step
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddIntervalBlockView(
            selectedType: .americanFootball,
            selectedLocation: .indoor,
            intervalBlocks: .constant([])
        )
    }
}
