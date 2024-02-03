//
//  StringExtension.swift
//  WorkoutBuilder
//
//  Created by Gabriel Zawalski on 02/02/24.
//

import Foundation

extension String {
    func dotCase() -> String {
        let stripWhiteSpaces = self.replacingOccurrences(of: " ", with: "", options: .regularExpression, range: range(of: self))
        let dotCased = stripWhiteSpaces.replacingOccurrences(of: "([A-Z])", with: ".$1", options: .regularExpression, range: range(of: stripWhiteSpaces))
        let lowercased = dotCased.lowercased()
        
        return lowercased
    }
}
