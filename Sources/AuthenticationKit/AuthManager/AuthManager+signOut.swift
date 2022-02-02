//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



extension AuthManager {
    
    
    // MARK: - Sign Out -
    public func signOut() { run(signOutWork) }
    public func signOut() async { await run(signOutWork) }
    private func signOutWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        try await authenticator.signOut(user: user)
        authenticator.currentUser = nil
        try await authenticator.removeRemoteUpdatesListners(for: user)
    }
    
    
}
