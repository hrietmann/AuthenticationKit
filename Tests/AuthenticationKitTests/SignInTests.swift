//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import XCTest
@testable import AuthenticationKit

final class SignInTests: XCTestCase {
    
    
    @MainActor func test_authentication_manager_sign_in_successfull() async throws {
        
        var user = AKTestAuthenticator.User.exemple
        user.username = "Username"
        user.email = "email@email.com"
        let authenticator = AKTestAuthenticator()
        authenticator.signInResult = .success(user)
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        sut.emailEntry = user.email ?? ""
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signIn()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.user)
        XCTAssertTrue(sut.user?.username == user.username)
        XCTAssertTrue(sut.user?.email == user.email)
        XCTAssertTrue(sut.state.isConnected)
    }
    
    
    @MainActor func test_authentication_manager_sign_in_server_failed() async throws {
        
        let serverError = AKError("Internal server error")
        let authenticator = AKTestAuthenticator()
        authenticator.signInResult = .failure(serverError)
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        sut.emailEntry = "email@email.com"
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signIn()
        
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isDisconnected)
    }
    
    
    @MainActor func test_authentication_manager_sign_up_missing_credentials() async throws {
        
        let authenticator = AKTestAuthenticator()
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        
        // Missing all
        sut.emailEntry = ""
        sut.passwordEntry = ""
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isDisconnected)
        
        // Missing email
        sut.emailEntry = ""
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isDisconnected)
        
        // Missing password
        sut.emailEntry = "email@email.com"
        sut.passwordEntry = ""
        await sut.signUp()
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isDisconnected)
    }
    
    @MainActor func test_authentication_manager_sign_in_while_signed_in() async throws {
        
        var user = AKTestAuthenticator.User.exemple
        user.username = "Username"
        user.email = "email@email.com"
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        sut.emailEntry = user.email ?? ""
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signIn()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isConnected)
    }
    
    
}
