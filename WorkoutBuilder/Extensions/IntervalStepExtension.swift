//
//  BlockStepExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit

extension IntervalStep.Purpose {
    var description: String {
        switch self {
        case .work: return "Work"
        case .recovery: return "Rest"
        @unknown default: return ""
        }
    }
}
