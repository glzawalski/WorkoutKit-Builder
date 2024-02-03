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
    @State private var type: ActivityType = .other

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
        }
    }
}

struct ActivityTypeItem: View {
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
                .strokeBorder(.black, lineWidth: 5)
        )
    }
}

#Preview {
    ActivitySelection()
}
