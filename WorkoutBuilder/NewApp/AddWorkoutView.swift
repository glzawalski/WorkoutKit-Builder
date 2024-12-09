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
    @State private var selectedType: HKWorkoutActivityType?
    @State private var selectedLocation: HKWorkoutSessionLocationType = .outdoor
    @State private var selectedLocationToggle: Bool = false
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
            Group {
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
            .opacity(selectedType != nil ? 1 : 0)
            .animation(.bouncy.delay(0.5), value: selectedType != nil)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            workoutType
                .opacity(selectedType != nil ? 1 : 0)
                .animation(.bouncy.delay(0.2), value: selectedType != nil)

            workoutTypePicker
                .opacity(selectedType == nil ? 1 : 0)
                .animation(.default, value: selectedType == nil)
        }
    }

    var workoutName: some View {
        TextField("My Workout", text: $name, axis: .vertical)
            .font(.title)
            .multilineTextAlignment(.center)
    }

    var workoutTypePicker: some View {
        ZStack {
            Color.white

            CenteredScrollView(.horizontal) {
                LazyHStack {
                    ForEach(HKWorkoutActivityType.supportedCases, id: \.self) { type in
                        VStack {
                            Image(systemName: type.displayImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            Text(type.displayName)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background {
                            Color.gray.opacity(0.4).cornerRadius(16)
                        }
                        .onTapGesture {
                            selectedType = type
                            name = "My \(type.displayName) Workout"
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal)
        }
    }

    var workoutType: some View {
        Image(systemName: selectedType?.displayImage ?? "")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(0.2)
            .padding(.horizontal)
    }

    var workoutLocation: some View {
        Picker("Select Location", selection: $selectedLocation) {
            ForEach(HKWorkoutSessionLocationType.allCases, id:\.self) { location in
                Text(location.displayName)
                    .tag(location)
            }
        }
        .padding(.horizontal)
        .pickerStyle(.segmented)
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
    let axes: Axis.Set
    let content: Content

    init(_ axes: Axis.Set = .vertical, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.content = content()
    }

    var body: some View {
        ScrollView(axes) {
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
