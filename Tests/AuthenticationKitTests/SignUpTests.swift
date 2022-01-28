//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import XCTest
@testable import AuthenticationKit

final class SignUpTests: XCTestCase {
    
    
    @MainActor func test_authentication_manager_sign_up_successfull() async throws {
        
        var user = AKTestAuthenticator.User.exemple
        user.username = "Username"
        user.email = "email@email.com"
        let authenticator = AKTestAuthenticator()
        authenticator.signUpResult = .success(user)
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        sut.usernameEntry = user.username ?? ""
        sut.emailEntry = user.email ?? ""
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.user)
        XCTAssertTrue(sut.state.isConnected)
    }
    
    
    @MainActor func test_authentication_manager_sign_up_server_failed() async throws {
        
        let serverError = AKError("Internal server error")
        let authenticator = AKTestAuthenticator()
        authenticator.signUpResult = .failure(serverError)
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        sut.usernameEntry = "Username"
        sut.emailEntry = "email@email.com"
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.state.isConnected)
    }
    
    
    @MainActor func test_authentication_manager_sign_up_missing_credentials() async throws {
        
        let authenticator = AKTestAuthenticator()
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        
        // Missing all
        sut.usernameEntry = ""
        sut.emailEntry = ""
        sut.passwordEntry = ""
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.state.isConnected)
        
        // Missing username
        sut.usernameEntry = ""
        sut.emailEntry = "email@email.com"
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.state.isConnected)
        
        // Missing email
        sut.usernameEntry = "Username"
        sut.emailEntry = ""
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.state.isConnected)
        
        // Missing password
        sut.usernameEntry = "Username"
        sut.emailEntry = "email@email.com"
        sut.passwordEntry = ""
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.state.isConnected)
    }
    
    @MainActor func test_authentication_manager_sign_up_while_signed_in() async throws {
        
        var user = AKTestAuthenticator.User.exemple
        user.username = "Username"
        user.email = "email@email.com"
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        sut.usernameEntry = user.username ?? ""
        sut.emailEntry = user.email ?? ""
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isConnected)
    }
    
    
}
