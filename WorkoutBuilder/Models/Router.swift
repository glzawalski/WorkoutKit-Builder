//
//  Router.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 05/02/24.
//

import Foundation
import SwiftUI
import WorkoutKit

enum Destination: Hashable {
    case activitySelection
    case locationSelection
    case warmup
    case intervalBlocks
    case cooldown
    case goal(Binding<WorkoutGoal>)
    case alert(Binding<(any WorkoutAlert)?>)
    case intervalBlock(IntervalBlock)
    case intervalBlockStep(Binding<IntervalStep>)

    static func == (lhs: Destination, rhs: Destination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .activitySelection:
            hasher.combine(1)
        case .locationSelection:
            hasher.combine(2)
        case .warmup:
            hasher.combine(3)
        case .intervalBlocks:
            hasher.combine(4)
        case .cooldown:
            hasher.combine(5)
        case .goal(let goal):
            hasher.combine(goal.wrappedValue)
        case .alert(let alert):
            if let workoutAlert = alert.wrappedValue {
                hasher.combine(workoutAlert)
            }
        case .intervalBlock(let intervalBlock):
            hasher.combine(intervalBlock)
        case .intervalBlockStep(let intervalStep):
            hasher.combine(intervalStep.wrappedValue)
        }
    }
}

final class Router: ObservableObject {
    @Published var navPath = [Destination]()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
