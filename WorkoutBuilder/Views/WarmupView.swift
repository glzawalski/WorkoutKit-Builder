//
//  WarmupView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import SwiftUI
import WorkoutKit

struct WarmupView: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    @State var goal: WorkoutGoal = .open
    @State var alert: (any WorkoutAlert)?

    var body: some View {
        VStack {
            Spacer()

            Button(
                action: {
                    router.navigate(to: .goal($goal))
                },
                label: {
                    Text("\(goal.description). Tap to edit")
                }
            )

            Button(
                action: {
                    router.navigate(to: .alert($alert))
                },
                label: {
                    Text("\(alert?.description ?? "No alert"). Tap to edit")
                }
            )

            Spacer()

            HStack {
                Button(
                    action: {
                        goal = .open
                        alert = nil
                        model.warmupStep = nil
                        router.navigate(to: .intervalBlocks)
                    },
                    label: {
                        Text("Skip")
                    }
                )

                Button(
                    action: {
                        model.warmupStep = WorkoutStep(goal: goal, alert: alert)
                        router.navigate(to: .intervalBlocks)
                    },
                    label: {
                        Text("Next")
                    }
                )
            }
        }
        .navigationTitle("Warmup")
    }
}

#Preview {
    WarmupView()
        .environmentObject(CustomWorkoutModel())
        .environmentObject(Router())
}
