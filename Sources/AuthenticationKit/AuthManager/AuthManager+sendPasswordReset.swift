//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



extension AuthManager {
    
    
    // MARK: - Send Password Reset Email -
    public func sendPasswordResetEmail() { run(sendPasswordResetEmailWork) }
    public func sendPasswordResetEmail() async { await run(sendPasswordResetEmailWork) }
    private func sendPasswordResetEmailWork() async throws {
        if let emailError = emailError { throw emailError }
        try await authenticator.sendPasswordReset(to: emailEntry)
    }
    
    
}
