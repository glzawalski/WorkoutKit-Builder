//
//  CooldownView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import SwiftUI
import WorkoutKit

struct CooldownView: View {
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
                        model.cooldownStep = nil
                        model.makeCustomWorkout()
                        router.navigateToRoot()
                    },
                    label: {
                        Text("Skip")
                    }
                )

                Button(
                    action: {
                        model.cooldownStep = WorkoutStep(goal: goal, alert: alert)
                        model.makeCustomWorkout()
                        router.navigateToRoot()
                    },
                    label: {
                        Text("Finish")
                    }
                )
            }
        }
        .navigationTitle("Cooldown")
    }
}

#Preview {
    CooldownView()
        .environmentObject(CustomWorkoutModel())
        .environmentObject(Router())
}
