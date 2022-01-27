//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation





public struct AKError: LocalizedError, Codable {
    
    public let reason: String?
    public let message: String?
    public let error: String?
    
    public init(_ reason: String) {
        self.reason = reason
        self.message = nil
        self.error = nil
    }
    
    public init(_ error: Error) {
        self.reason = nil
        self.message = nil
        self.error = error.localizedDescription
    }
    
    public var errorDescription: String? {
        reason ?? message ?? error
    }
    
}
