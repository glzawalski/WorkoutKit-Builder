//
//  AddWorkout.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 06/12/24.
//

import SwiftUI
import HealthKit
import WorkoutKit

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var workouts: [Workout]

    @State private var name: String = "My Workout"
    @State private var selectedType: HKWorkoutActivityType = .americanFootball
    @State private var selectedLocation: HKWorkoutSessionLocationType = .outdoor
    @State private var warmup: WorkoutStep = .init(
        goal: .distance(1, .kilometers),
        alert: SpeedThresholdAlert(
            target: .init(value: 1, unit: .kilometersPerHour),
            metric: .average
        )
    )
    @State private var intervalBlocks: [IntervalBlock] = [
        .init(
            steps: [
                IntervalStep(
                    .work,
                    goal: .distance(1, .kilometers),
                    alert: SpeedThresholdAlert(
                        target: .init(value: 1, unit: .kilometersPerHour),
                        metric: .average
                    )
                ),
                IntervalStep(
                    .work,
                    goal: .distance(1, .kilometers),
                    alert: SpeedThresholdAlert(
                        target: .init(value: 1, unit: .kilometersPerHour),
                        metric: .average
                    )
                )
            ],
            iterations: 1
        ),
        .init(
            steps: [
                IntervalStep(
                    .recovery,
                    goal: .distance(1, .kilometers),
                    alert: SpeedThresholdAlert(
                        target: .init(value: 1, unit: .kilometersPerHour),
                        metric: .average
                    )
                ),
                IntervalStep(
                    .work,
                    goal: .distance(1, .kilometers),
                    alert: SpeedThresholdAlert(
                        target: .init(value: 1, unit: .kilometersPerHour),
                        metric: .average
                    )
                ),
                IntervalStep(
                    .recovery,
                    goal: .distance(1, .kilometers),
                    alert: SpeedThresholdAlert(
                        target: .init(value: 1, unit: .kilometersPerHour),
                        metric: .average
                    )
                )
            ],
            iterations: 2
        )
    ]
    @State private var cooldown: WorkoutStep = .init(
        goal: .distance(1, .kilometers),
        alert: SpeedThresholdAlert(
            target: .init(value: 1, unit: .kilometersPerHour),
            metric: .average
        )
    )

    var body: some View {
        VStack() {
            workoutName

            Spacer().frame(height: 30)

            workoutLocation

            Spacer().frame(height: 100)

            TabView {
                warmupSummary

                intervalBlocksSummary

                cooldownSummary
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .padding(.bottom)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            workoutType
        }
    }

    var workoutName: some View {
        Text(name)
            .font(.title)
    }

    var workoutType: some View {
        Image(systemName: selectedType.displayImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(0.2)
            .padding(.horizontal)
    }

    var workoutLocation: some View {
        Text(selectedLocation.displayName)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
    }

    var warmupSummary: some View {
        CenteredScrollView {
            VStack {
                Text("Warmup")
                Text(warmup.goal.description)
                Text(warmup.alert?.description ?? "")
            }
        }
    }

    var intervalBlocksSummary: some View {
        CenteredScrollView {
            HStack {
                ForEach($intervalBlocks) { block in
                    VStack {
                        Text("Block")
                        ForEach(block.steps) { step in
                            Text(step.purpose.wrappedValue.description)
                        }
                        Text(block.iterations.wrappedValue.description)
                    }
                }
            }
        }
    }

    var cooldownSummary: some View {
        CenteredScrollView {
            VStack {
                Text("Cooldown")
                Text(cooldown.goal.description)
                Text(cooldown.alert?.description ?? "")
            }
        }
    }
}

struct CenteredScrollView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView {
            ZStack {
                Spacer().containerRelativeFrame([.horizontal, .vertical])

                content
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AddWorkoutView(workouts: .constant([]))
}

// https://stackademic.com/blog/swiftui-dropdown-menu-3-ways-picker-menu-and-custom-from-scratch
// https://programmingwithswift.com/numbers-only-textfield-with-swiftui/
