//
//  BlockStepExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit

extension IntervalStep: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

extension IntervalStep.Purpose {
    var icon: String {
        switch self {
        case .work: return "dumbbell"
        case .recovery: return "zzz"
        @unknown default: return ""
        }
    }

    var description: String {
        switch self {
        case .work: return "Work"
        case .recovery: return "Rest"
        @unknown default: return ""
        }
    }
}
