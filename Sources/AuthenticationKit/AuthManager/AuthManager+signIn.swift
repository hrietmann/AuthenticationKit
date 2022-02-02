//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



extension AuthManager {
    
    
    // MARK: - Sign In -
    public func signIn() { run(signInWork) }
    public func signIn() async { await run(signInWork) }
    private func signInWork() async throws {
        guard user == nil else { throw UserAlreadySignedIn(localizationFile: errorsLocalizationFile) }
        if let error = emailError ?? passwordError { throw error }
        let newUser = try await authenticator.signIn(
            email: emailEntry,
            password: passwordEntry)
        authenticator.currentUser = newUser
        try await authenticator.addRemoteUpdatesLisnters(for: newUser)
    }
    
    
}
