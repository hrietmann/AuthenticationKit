//
//  File.swift
//  
//
//  Created by Hans Rietmann on 28/01/2022.
//

import Foundation





public struct PasswordMismatch: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.PasswordMismatch".localized(fromFile: localizationFile)
    }
    
    
}
