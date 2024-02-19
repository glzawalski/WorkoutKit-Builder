//
//  PrimaryView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 05/02/24.
//

import SwiftUI

struct PrimaryView: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack {
                ForEach(model.customWorkouts) { workout in
                    Text("\(workout.id)")
                }

                Spacer()

                Button("Add new") {
                    router.navigate(to: .activitySelection)
                }
            }
            .navigationDestination(for: Destination.self) { path in
                switch path {
                case .activitySelection:
                    ActivitySelection()
                case .locationSelection:
                    LocationSelection()
                case .warmup:
                    WarmupView()
                case .intervalBlocks:
                    IntervalBlocksView()
                case .intervalBlockStep(let intervalStep):
                    IntervalBlockStepView(step: intervalStep)
                case .cooldown:
                    CooldownView()
                case .goal(let goal):
                    GoalView(goal: goal)
                case .alert(let alert):
                    AlertView(alert: alert)
                case .intervalBlock(let intervalBlock):
                    IntervalBlockView(intervalBlock: intervalBlock)
                }
            }
        }
    }
}

#Preview {
    PrimaryView()
        .environmentObject(CustomWorkoutModel())
        .environmentObject(Router())
}
