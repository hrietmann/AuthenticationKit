//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



extension AuthManager {
    
    
    // MARK: - Change Email -
    public func changeEmail() { run(changeEmailWork) }
    public func changeEmail() async { await run(changeEmailWork) }
    func changeEmailWork()  async throws {
        if let error = emailError ?? passwordError { throw error }
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard user.email != emailEntry else { return }
        try await authenticator.change(email: emailEntry, with: passwordEntry, of: user)
    }
    
    
}
