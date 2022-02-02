//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - Sign Up -
    public func signUp() { run(signUpWork) }
    public func signUp() async { await run(signUpWork) }
    private func signUpWork() async throws {
        guard user == nil else { throw UserAlreadySignedIn(localizationFile: errorsLocalizationFile) }
        if let error = usernameError ?? emailError ?? passwordError ?? password2Error { throw error }
        let newUser = try await authenticator.signUp(
            username: usernameEntry,
            email: emailEntry,
            password: passwordEntry)
        authenticator.currentUser = newUser
        try await authenticator.addRemoteUpdatesLisnters(for: newUser)
    }
    
    
}
