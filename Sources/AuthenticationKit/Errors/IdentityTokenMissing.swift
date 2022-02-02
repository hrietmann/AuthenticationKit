//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




public struct IdentityTokenMissing: LocalizedError {
    
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.IdentityTokenMissing".localized(fromFile: localizationFile)
    }
    
    
}
