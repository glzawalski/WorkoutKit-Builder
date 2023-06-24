//
//  IntervalBlockExtensions.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 21/06/23.
//

import Foundation
import WorkoutKit

extension IntervalBlock: Identifiable {
    public var id: UUID {
        return UUID()
    }
}
