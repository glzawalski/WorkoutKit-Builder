//
//  BlockStepExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit

extension BlockStep: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

extension BlockStep.StepType {
    var icon: String {
        switch self {
        case .work: return "dumbbell"
        case .rest: return "zzz"
        @unknown default: return ""
        }
    }

    var description: String {
        switch self {
        case .work: return "Work"
        case .rest: return "Rest"
        @unknown default: return ""
        }
    }
}
