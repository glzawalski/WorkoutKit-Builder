//
//  ContentView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 20/06/23.
//

import SwiftUI
import WorkoutKit
import HealthKit

struct ContentView: View {
    @State private var type: HKWorkoutActivityType = .other
    @State private var location: HKWorkoutSessionLocationType = .unknown
    @State private var displayName: String = ""

    @State private var warmupStep: WorkoutStep?
    @State private var addWarmup: Bool = false

    @State private var intervalBlocks: [IntervalBlock] = []
    @State private var selectedBlock: Int?
    @State private var addIntervalBlock: Bool = false
    @State private var editIntervalBlock: Bool = false

    @State private var cooldownStep: WorkoutStep?
    @State private var addCooldown: Bool = false

    @State private var presentAlert: Bool = false
    @State private var alertText: String = ""

    @State private var presentWorkout: Bool = false

    private var workoutPlan: WorkoutPlan {
        return .init(
            .custom(
                CustomWorkout(
                    activity: type,
                    location: location,
                    displayName: displayName,
                    warmup: warmupStep,
                    blocks: intervalBlocks,
                    cooldown: cooldownStep
                )
            )
        )
    }

    var body: some View {
        Form {
            typePicker

            locationPicker

            nameTextField

            warmupSection

            intervalBlockSection

            cooldownSection

            presentWorkoutPreviewButton
        }
        .sheet(isPresented: $addWarmup) {
            WorkoutStepView(
                workoutStep: $warmupStep,
                title: "Add Warmup",
                type: type,
                location: location
            )
        }
        .sheet(isPresented: $addIntervalBlock) {
            IntervalBlockView(
                intervalBlocks: $intervalBlocks,
                selectedBlock: .constant(nil),
                addingNew: true,
                type: type,
                location: location
            )
        }
        .sheet(isPresented: $editIntervalBlock) {
            IntervalBlockView(
                intervalBlocks: $intervalBlocks,
                selectedBlock: $selectedBlock,
                addingNew: false,
                type: type,
                location: location
            )
        }
        .sheet(isPresented: $addCooldown) {
            WorkoutStepView(
                workoutStep: $cooldownStep,
                title: "Add Cooldown",
                type: type,
                location: location
            )
        }
        .alert(alertText, isPresented: $presentAlert) {
            Button {
                presentAlert.toggle()
            } label: {
                Text("OK")
            }
        }
        .workoutPreview(workoutPlan, isPresented: $presentWorkout)
    }
}

private extension ContentView {
    var typePicker: some View {
        Section("Activity") {
            Picker("Type", selection: $type) {
                ForEach(HKWorkoutActivityType.supportedCases, id: \.self) { item in
                    Text("\(item.displayName)")
                        .tag(item)
                }
            }
        }
    }

    var locationPicker: some View {
        Section("Location") {
            Picker("Type", selection: $location) {
                ForEach(HKWorkoutSessionLocationType.allCases, id: \.self) { item in
                    Text("\(item.displayName)")
                        .tag(item)
                }
            }
        }
    }

    var nameTextField: some View {
        HStack {
            Text("Name")
            TextField("Workout name", text: $displayName)
                .multilineTextAlignment(.trailing)
        }
    }

    var warmupSection: some View {
        Section("Warmup") {
            if let warmupStep {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "checkmark.square")
                            Text(": \(warmupStep.goal.description)")
                        }

                        HStack {
                            Image(systemName: "bell.circle")
                            Text(": \(warmupStep.alert.debugDescription)")
                        }
                    }

                    Spacer()

                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .onTapGesture {
                    addWarmup.toggle()
                }
            } else {
                Button("Add Step") {
                    addWarmup.toggle()
                }
            }
        }
    }

    var intervalBlockSection: some View {
        Section("Blocks") {
            List {
                ForEach(0..<intervalBlocks.count, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        let block = intervalBlocks[index]

                        HStack {
                            ForEach(block.steps) { step in
                                Image(systemName: step.purpose.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                            }

                            Image(systemName: "repeat")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)

                            Text("\(block.iterations)")

                            Spacer()

                            Image(systemName: "pencil.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .onTapGesture {
                                    selectedBlock = index
                                    editIntervalBlock.toggle()
                                }
                        }
                    }
                }
            }

            Button("Add Block") {
                addIntervalBlock.toggle()
            }
        }
    }

    var cooldownSection: some View {
        Section("Cooldown") {
            if let cooldownStep {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "checkmark.square")
                            Text(": \(cooldownStep.goal.description)")
                        }

                        HStack {
                            Image(systemName: "bell.circle")
                            Text(": \(cooldownStep.alert.debugDescription)")
                        }
                    }

                    Spacer()

                    Image(systemName: "pencil.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .onTapGesture {
                    addCooldown.toggle()
                }
            } else {
                Button("Add Step") {
                    addCooldown.toggle()
                }
            }
        }
    }

    var presentWorkoutPreviewButton: some View {
        Button {
            presentWorkout.toggle()
        } label: {
            Text("Present Preview")
        }

    }
}

#Preview {
    ContentView()
}
