//
//  WorkoutGoalSection.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/08/23.
//

import SwiftUI

struct WorkoutGoalSection: View {
    @Binding var type: GoalType
    @Binding var unit: GoalUnit?
    @Binding var value: Double

    var body: some View {
        Section("Goal") {
            typePicker

            switch type {
            case .distance:
                lengthUnitPicker
                valueInput

            case .energy:
                energyUnitPicker
                valueInput

            case .time:
                timeUnitPicker
                valueInput

            case .open:
                EmptyView()
            }
        }
    }
}

extension WorkoutGoalSection {
    var typePicker: some View {
        Picker("Type", selection: $type) {
            ForEach(GoalType.allCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item)
            }
        }
    }

    var lengthUnitPicker: some View {
        Picker("Unit", selection: $unit) {
            Text("None")
                .tag(nil as GoalUnit?)
            ForEach(GoalUnit.lengthCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as GoalUnit?)
            }
        }
    }

    var energyUnitPicker: some View {
        Picker("Unit", selection: $unit) {
            Text("None")
                .tag(nil as GoalUnit?)
            ForEach(GoalUnit.energyCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as GoalUnit?)
            }
        }
    }

    var timeUnitPicker: some View {
        Picker("Unit", selection: $unit) {
            Text("None")
                .tag(nil as GoalUnit?)
            ForEach(GoalUnit.timeCases, id: \.self) { item in
                Text("\(item.rawValue)")
                    .tag(item as GoalUnit?)
            }
        }
    }

    var valueInput: some View {
        HStack {
            Text("Value")
            TextField("Goal Value", value: $value, formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
        }
    }
}

#Preview {
    WorkoutGoalSection(type: .constant(.open), unit: .constant(nil), value: .constant(.zero))
}

enum GoalType: String, CaseIterable {
    case distance = "Distance"
    case energy = "Energy"
    case time = "Time"
    case open = "Open"
}

enum GoalUnit: String {
    case kilometers = "Kilometers"
    case meters = "Meters"
    case centimeters = "Centimeters"
    case feet = "Feet"
    case yards = "Yards"
    case miles = "Miles"

    static var lengthCases: [GoalUnit] {
        [.kilometers, .meters, .centimeters, .feet, .yards, .miles]
    }

    case kilojoules = "Kilojoules"
    case joules = "Joules"
    case kilocalories = "Kilocalories"
    case calories = "Calories"
    case kilowattHours = "Kilowatt Hours"

    static var energyCases: [GoalUnit] {
        [.kilojoules, .joules, .kilocalories, .calories, .kilowattHours]
    }

    case hours = "Hours"
    case minutes = "Minutes"
    case seconds = "Seconds"

    static var timeCases: [GoalUnit] {
        [.hours, .minutes, .seconds]
    }
}
