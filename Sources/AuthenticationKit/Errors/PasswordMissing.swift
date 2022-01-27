//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation




public struct PasswordMissing: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.PasswordMissing".localized(fromFile: localizationFile)
    }
    
    
}
