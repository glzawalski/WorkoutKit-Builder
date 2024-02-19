//
//  IntervalBlocksView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 17/02/24.
//

import SwiftUI
import WorkoutKit

struct IntervalBlocksView: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            ScrollView {
                ForEach(model.intervalBlocks) { intervalBlock in
                    Button(
                        action: {
                            router.navigate(to: .intervalBlock(intervalBlock))
                        },
                        label: {
                            Text(
                                "\(intervalBlock.id)"
                            )
                        }
                    )
                }

                Spacer()

                Button(
                    action: {
                        model.intervalBlocks.append(IntervalBlock())
//                        if let binding = $model.intervalBlocks.last {
//                            router.navigate(to: .intervalBlock(binding))
//                        }
                    },
                    label: {
                        Text(
                            "Add new"
                        )
                    }
                )
            }

            Button(
                action: {
                    router.navigate(to: .cooldown)
                },
                label: {
                    Text("Skip")
                }
            )
        }
        .navigationTitle("Interval Blocks")
    }
}

#Preview {
    let intervalStep = IntervalStep(.recovery, goal: .open, alert: nil)
    let intervalBlock = IntervalBlock(steps: [intervalStep], iterations: 1)
    let model = CustomWorkoutModel()
    model.intervalBlocks.append(intervalBlock)

    return IntervalBlocksView()
        .environmentObject(model)
        .environmentObject(Router())
}
