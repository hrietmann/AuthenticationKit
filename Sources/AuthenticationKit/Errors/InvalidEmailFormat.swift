//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation



public struct InvalidEmailFormat: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.InvalidEmailFormat".localized(fromFile: localizationFile)
    }
    
    
}
