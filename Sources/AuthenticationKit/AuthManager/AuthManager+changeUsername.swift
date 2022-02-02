//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - Change Username -
    public func changeUsername() { run(changeUsernameWork) }
    public func changeUsername() async { await run(changeUsernameWork) }
    private func changeUsernameWork() async throws {
        if let error = usernameError { throw error }
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard user.username != usernameEntry else { return }
        try await authenticator.change(username: usernameEntry, of: user)
    }
    
    
}
