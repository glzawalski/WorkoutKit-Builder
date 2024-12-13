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

    @State private var selectedLocation: HKWorkoutSessionLocationType = .indoor

    @State private var selectedLocationToggle: Bool = false

    @State private var hasWarmup: Bool = false
    @State private var warmup: WorkoutStep = .init()

    @State private var intervalBlocks: [IntervalBlock] = []

    @State private var hasCooldown: Bool = false
    @State private var cooldown: WorkoutStep = .init()

    var body: some View {
        NavigationStack {
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
            ZStack {
                Button("Add warmup") {
                    hasWarmup.toggle()
                }
                .opacity(hasWarmup ? 0 : 1)
                .frame(maxHeight: hasWarmup ? 0 : nil)
                .animation(.default, value: hasWarmup)

                VStack {
                    if let selectedType {
                        AddGoalAlertView(
                            activity: selectedType,
                            location: selectedLocation,
                            workoutStep: $warmup
                        )
                    }
                    Button("Remove warmup") {
                        hasWarmup.toggle()
                    }
                }
                .opacity(hasWarmup ? 1 : 0)
                .frame(maxHeight: hasWarmup ? nil : 0)
                .animation(.default, value: hasWarmup)
            }
        }
    }

    var intervalBlocksSummary: some View {
        CenteredScrollView(.vertical) {
            if let selectedType {
                AddIntervalBlockView(
                    selectedType: selectedType,
                    selectedLocation: selectedLocation,
                    intervalBlocks: $intervalBlocks
                )
            }
        }
    }

    var cooldownSummary: some View {
        CenteredScrollView {
            ZStack {
                Button("Add cooldown") {
                    hasCooldown.toggle()
                }
                .opacity(hasCooldown ? 0 : 1)
                .frame(maxHeight: hasCooldown ? 0 : nil)
                .animation(.default, value: hasCooldown)

                VStack {
                    if let selectedType {
                        AddGoalAlertView(
                            activity: selectedType,
                            location: selectedLocation,
                            workoutStep: $cooldown
                        )
                    }
                    Button("Remove cooldwon") {
                        hasCooldown.toggle()
                    }
                }
                .opacity(hasCooldown ? 1 : 0)
                .frame(maxHeight: hasCooldown ? nil : 0)
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
                Spacer().containerRelativeFrame([axes])

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
