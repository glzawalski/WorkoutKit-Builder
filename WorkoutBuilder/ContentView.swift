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

    @State private var warmupStep: WarmupStep?
    @State private var addWarmup: Bool = false

    @State private var intervalBlocks: [IntervalBlock] = []
    @State private var selectedBlock: Int?
    @State private var addIntervalBlock: Bool = false
    @State private var editIntervalBlock: Bool = false

    @State private var cooldownStep: CooldownStep?
    @State private var addCooldown: Bool = false

    @State private var presentAlert: Bool = false
    @State private var alertText: String = ""

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
            WarmupStepView(warmupStep: $warmupStep, title: warmupStep == nil ? "Add Warmup" : "Edit Warmup")
        }
        .sheet(isPresented: $addIntervalBlock) {
            IntervalBlockView(intervalBlocks: $intervalBlocks, selectedBlock: .constant(nil), addingNew: true)
        }
        .sheet(isPresented: $editIntervalBlock) {
            IntervalBlockView(intervalBlocks: $intervalBlocks, selectedBlock: $selectedBlock, addingNew: false)
        }
        .sheet(isPresented: $addCooldown) {
            CooldownStepView(cooldownStep: $cooldownStep, title: cooldownStep == nil ? "Add Cooldown" : "Edit Cooldown")
        }
        .alert(alertText, isPresented: $presentAlert) {
            Button {
                presentAlert.toggle()
            } label: {
                Text("OK")
            }
        }
    }
}

private extension ContentView {
    var typePicker: some View {
        Section("Activity") {
            Picker("Type", selection: $type) {
                ForEach(HKWorkoutActivityType.allCases, id: \.self) { item in
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
                            Text(": \(warmupStep.goal?.description ?? "No goal")")
                        }
                        
                        HStack {
                            Image(systemName: "bell.circle")
                            Text(": \(warmupStep.alert?.description ?? "No alert")")
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
                                Image(systemName: step.type.icon)
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
                            Text(": \(cooldownStep.goal?.description ?? "No goal")")
                        }

                        HStack {
                            Image(systemName: "bell.circle")
                            Text(": \(cooldownStep.alert?.description ?? "No alert")")
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
            do {
                let composition = try createCustomWorkoutComposition()
                let customWorkout = WorkoutComposition(customComposition: composition)

                Task {
                    try await customWorkout.presentPreview()
                }
            } catch {
                alertText = error.localizedDescription
                presentAlert.toggle()
            }
        } label: {
            Text("Present Preview")
        }

    }

    func createCustomWorkoutComposition() throws -> CustomWorkoutComposition {
        return try CustomWorkoutComposition(activity: type, location: location, displayName: displayName, warmup: warmupStep, blocks: intervalBlocks, cooldown: cooldownStep)
    }
}

#Preview {
    ContentView()
}
