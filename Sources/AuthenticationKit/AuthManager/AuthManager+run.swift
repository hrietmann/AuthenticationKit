//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    func run(_ work: @escaping () async throws -> ()) {
        Task { await run(work) }
    }
    func run(_ work: @escaping () async throws -> ()) async {
        error = nil
        state = .loading
        taskCompleted = false
        do {
            try await work()
            Task { @MainActor in
                passwordEntry = ""
                passwordEntry2 = ""
                taskCompleted = true
            }
        }
        catch {
            self.error = error
            taskCompleted = true
            guard let user = user
            else { state = .disconnected ; return }
            state = .connected(user: user)
        }
    }
    
    
}
