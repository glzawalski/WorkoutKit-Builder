//
//  ActivitySelection.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 02/02/24.
//

import SwiftUI
import HealthKit

typealias ActivityType = HKWorkoutActivityType

struct ActivitySelection: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    var body: some View {
        ScrollView {
            Grid {
                ForEach(ActivityType.chunks, id: \.self) { row in
                    GridRow {
                        ForEach(row, id: \.self) { type in
                            ActivityTypeItem(type: type)
                        }
                    }
                }
            }
            Button(
                action: {
                    model.activityType = .other
                    router.navigate(to: .locationSelection)
                },
                label: {
                    Label(
                        ActivityType.other.displayName,
                        systemImage: ActivityType.other.displayImage
                    )
                }
            )
        }
        .navigationTitle("Activity selection")
    }
}

struct ActivityTypeItem: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    let type: ActivityType

    var body: some View {
        VStack {
            Image(systemName: type.displayImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text("\(type.displayName)")
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(model.activityType == type ? .blue : .black, lineWidth: 5)
        )
        .onTapGesture {
            model.activityType = type
            router.navigate(to: .locationSelection)
        }
    }
}

#Preview {
    ActivitySelection()
        .environmentObject(CustomWorkoutModel())
}
