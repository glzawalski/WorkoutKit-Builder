//
//  IntervalBlockView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 17/02/24.
//

import SwiftUI
import WorkoutKit

struct IntervalBlockView: View {
    @EnvironmentObject var router: Router

    @State var intervalBlock: IntervalBlock

    var body: some View {
        ScrollView {
            if intervalBlock.steps.isEmpty {
                Text("No steps")
            }

            ForEach($intervalBlock.steps) { $step in
                Button(
                    action: {
                        router.navigate(to: .intervalBlockStep($step))
                    },
                    label: {
                        Text("\($step.id)")
                    }
                )
            }

            Button(
                action: {
                    intervalBlock.steps.append(IntervalStep(.work))
//                    if let binding = $intervalBlock.steps.last {
//                        router.navigate(to: .intervalBlockStep(binding))
//                    }
                },
                label: {
                    Text("Add step")
                }
            )

            HStack {
                Text("Iterations:")
                TextField("Iterations", value: $intervalBlock.iterations, formatter: NumberFormatter.integer)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("Interval Block")
    }
}

#Preview {
    IntervalBlockView(intervalBlock: IntervalBlock())
        .environmentObject(Router())
}
