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
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            Spacer()

            LocationTypeItem(type: .indoor)
            LocationTypeItem(type: .outdoor)

            Spacer()

            Button(
                action: {
                    model.locationType = .unknown
                    router.navigate(to: .warmup)
                },
                label: {
                    Label(
                        LocationType.unknown.displayName,
                        systemImage: LocationType.unknown.displayImage
                    )
                }
            )
        }
        .navigationTitle("Location selection")
    }
}

struct LocationTypeItem: View {
    @EnvironmentObject var model: CustomWorkoutModel
    @EnvironmentObject var router: Router

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
                .strokeBorder(model.locationType == type ? .blue : .black, lineWidth: 5)
        )
        .onTapGesture {
            model.locationType = type
            router.navigate(to: .warmup)
        }
    }
}

#Preview {
    LocationSelection()
        .environmentObject(CustomWorkoutModel())
        .environmentObject(Router())
}
