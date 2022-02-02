//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



extension AuthManager {
    
    
    func setupCurrentUserListners() {
        authenticator.currentUserPublisher
            .receive(on: RunLoop.main)
            .sink { currentUser in
                guard let currentUser = currentUser else {
                    self.state = .disconnected
                    self.usernameEntry = ""
                    self.emailEntry = ""
                    self.passwordEntry = ""
                    self.passwordEntry2 = ""
                    self.profileImage = nil
                    return
                }
                self.state = .connected(user: currentUser)
                self.usernameEntry = currentUser.username ?? ""
                self.emailEntry = currentUser.email ?? ""
            }
            .store(in: &cancellables)
    }
 
    
}
