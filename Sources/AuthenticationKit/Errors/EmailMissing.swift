//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation




public struct EmailMissing: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.EmailMissing".localized(fromFile: localizationFile)
    }
    
    
}
