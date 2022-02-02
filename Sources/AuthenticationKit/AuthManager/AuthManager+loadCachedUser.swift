//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - loadCachedUser -
    func loadCachedUser() { run(loadCachedUserWork) }
    func loadCachedUser() async { await run(loadCachedUserWork) }
    private func loadCachedUserWork() async throws {
        let cachedUser = try await self.authenticator.cachedUser
        self.authenticator.currentUser = cachedUser
    }
    
    
}
