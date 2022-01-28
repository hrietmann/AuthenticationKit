//
//  File.swift
//  
//
//  Created by Hans Rietmann on 28/01/2022.
//

import Foundation




public struct EmailAlreadyVerified: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.EmailAlreadyVerified".localized(fromFile: localizationFile)
    }
    
    
}

