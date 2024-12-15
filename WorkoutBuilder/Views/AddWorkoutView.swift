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
    @Environment(WorkoutBuilderAppState.self) private var state

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    workoutName

                    Spacer()

                    workoutLocation

                    Spacer()

                    TabView {
                        warmupSummary

                        intervalBlocksSummary

                        cooldownSummary
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .padding(.bottom)

                    Spacer()

                    Button("Add workout") {
                        state.addWorkout()
                        dismiss()
                    }
                }
                .opacity(state.activity != nil ? 1 : 0)
                .animation(.bouncy.delay(0.5), value: state.activity != nil)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                workoutType
                    .opacity(state.activity != nil ? 1 : 0)
                    .animation(.bouncy.delay(0.2), value: state.activity != nil)

                workoutTypePicker
                    .opacity(state.activity == nil ? 1 : 0)
                    .animation(.default, value: state.activity == nil)
            }
        }
    }

    var workoutName: some View {
        TextField("My Workout", text: Bindable(state).displayName, axis: .vertical)
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
                            state.activity = type
                            state.displayName = "My \(type.displayName) Workout"
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
        Image(systemName: state.activity?.displayImage ?? "")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(0.2)
            .padding(.horizontal)
    }

    var workoutLocation: some View {
        Picker("Select Location", selection: Bindable(state).location) {
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
                    state.hasWarmup.toggle()
                }
                .opacity(state.hasWarmup ? 0 : 1)
                .frame(maxHeight: state.hasWarmup ? 0 : nil)
                .animation(.default, value: state.hasWarmup)

                VStack {
                    AddWarmupView()
                    Button("Remove warmup") {
                        state.hasWarmup.toggle()
                    }
                }
                .opacity(state.hasWarmup ? 1 : 0)
                .frame(maxHeight: state.hasWarmup ? nil : 0)
                .animation(.default, value: state.hasWarmup)
            }
        }
    }

    var intervalBlocksSummary: some View {
        CenteredScrollView(.vertical) {
            AddIntervalBlockView()
        }
    }

    var cooldownSummary: some View {
        CenteredScrollView {
            ZStack {
                Button("Add cooldown") {
                    state.hasCooldown.toggle()
                }
                .opacity(state.hasCooldown ? 0 : 1)
                .frame(maxHeight: state.hasCooldown ? 0 : nil)
                .animation(.default, value: state.hasCooldown)

                VStack {
                    AddCooldownView()
                    Button("Remove cooldwon") {
                        state.hasCooldown.toggle()
                    }
                }
                .opacity(state.hasCooldown ? 1 : 0)
                .frame(maxHeight: state.hasCooldown ? nil : 0)
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

// https://stackademic.com/blog/swiftui-dropdown-menu-3-ways-picker-menu-and-custom-from-scratch
// https://programmingwithswift.com/numbers-only-textfield-with-swiftui/
