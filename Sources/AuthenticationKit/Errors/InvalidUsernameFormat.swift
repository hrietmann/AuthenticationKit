//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation




public struct InvalidUsernameFormat: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.InvalidUsernameFormat".localized(fromFile: localizationFile)
    }
    
    
}
