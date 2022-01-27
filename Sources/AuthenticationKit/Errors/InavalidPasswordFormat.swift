//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import StringKit



public struct InvalidPasswordFormat: LocalizedError {
    
    let localizationFile: String?
    let constaints: [PasswordConstraint]
    
    public var failureReason: String? {
        let constraintsString = constaints
            .map { constraint -> String in
                switch constraint {
                case .atLeastOneDigits: return "Error.InvalidPasswordFormat.atLeastOneDigits"
                case .atLeast8Characters: return "Error.InvalidPasswordFormat.atLeast8Characters"
                case .atLeastOneLowercaseLetter: return "Error.InvalidPasswordFormat.atLeastOneLowercaseLetter"
                case .atLeastOneUppercaseLetter: return "Error.InvalidPasswordFormat.atLeastOneUppercaseLetter"
                case .atLeastOneSpecialCharacter: return "Error.InvalidPasswordFormat.atLeastOneSpecialCharacter"
                }
            }
            .map { $0.localized(fromFile: localizationFile) }
        let localizedList = ListFormatter.localizedString(byJoining: constraintsString)
        
        return "Error.InvalidPasswordFormat".localized(fromFile: localizationFile, [localizedList])
    }
    
}
