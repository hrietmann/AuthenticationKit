//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - Change Password -
    public func changePassword() { run(changePasswordWork) }
    public func changePassword() async { await run(changePasswordWork) }
    private func changePasswordWork()  async throws {
        if let error = emailError ?? passwordError ?? password2Error { throw error }
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard user.email != emailEntry else { return }
        try await authenticator.change(password: passwordEntry, to: passwordEntry2, with: emailEntry, of: user)
    }
    
    
}
