//
//  LocationSelection.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 03/02/24.
//

import SwiftUI
import HealthKit

typealias LocationType = HKWorkoutSessionLocationType

struct LocationSelection: View {
    @State private var type: LocationType = .unknown

    var body: some View {
        VStack {
            Spacer()

            LocationTypeItem(type: .indoor)
            LocationTypeItem(type: .outdoor)

            Spacer()

            Button(
                action: {

                },
                label: {
                    Label(
                        LocationType.unknown.displayName,
                        systemImage: LocationType.unknown.displayImage
                    )
                }
            )
        }
    }
}

struct LocationTypeItem: View {
    let type: LocationType

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
    LocationSelection()
}
