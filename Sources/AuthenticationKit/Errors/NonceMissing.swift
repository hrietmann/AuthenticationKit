//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




public struct NonceMissing: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.NonceMissing".localized(fromFile: localizationFile)
    }
    
    
}
