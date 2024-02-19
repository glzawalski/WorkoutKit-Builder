//
//  IntervalBlockStepView.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 17/02/24.
//

import SwiftUI
import WorkoutKit

struct IntervalBlockStepView: View {
    @EnvironmentObject var model: CustomWorkoutModel

    @Binding var step: IntervalStep

    var body: some View {
        Text("\(step.id)")
        Text("\(step.purpose.description)")
        Text("\(step.step.goal.description)")
        Text("\(step.step.alert?.description ?? "")")
    }
}

#Preview {
    IntervalBlockStepView(step: .constant(IntervalStep(.work)))
        .environmentObject(CustomWorkoutModel())
}
