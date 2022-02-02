//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - Delete User -
    public func deleteUser() { run(deleteUserWork) }
    public func deleteUser() async { await run(deleteUserWork) }
    private func deleteUserWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        authenticator.currentUser = nil
        try await authenticator.delete(user: user)
    }
    
    
}
