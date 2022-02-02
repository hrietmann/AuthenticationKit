//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - Send Email Verification -
    public func sendEmailVerification() { run(sendEmailVerificationWork) }
    public func sendEmailVerification() async { await run(sendEmailVerificationWork) }
    private func sendEmailVerificationWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard !user.emailVerified else { throw EmailAlreadyVerified(localizationFile: errorsLocalizationFile) }
        if user.email == nil { try await changeEmailWork() }
        try await authenticator.sendEmailVerification(for: user)
    }
    
    
}
