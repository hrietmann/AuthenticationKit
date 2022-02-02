//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




public struct TokenSerializationFailure: LocalizedError {
    
    
    let token: Data
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.TokenSerializationFailure".localized(fromFile: localizationFile) + token.debugDescription
    }
    
    
}
