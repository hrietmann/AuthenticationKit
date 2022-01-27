//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation




public struct UserNotSignedIn: LocalizedError {
    
    let localizationFile: String?
    
    public var failureReason: String? {
        "Error.UserNotSignedIn".localized(fromFile: localizationFile)
    }
    
}
