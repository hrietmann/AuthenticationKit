//
//  File.swift
//  
//
//  Created by Hans Rietmann on 28/01/2022.
//


import XCTest
@testable import AuthenticationKit

final class ChangeEmailTests: XCTestCase {
    
    
    @MainActor func test_authentication_manager_change_email_successfull() async throws {
        
        let newEmail = "azertyuiop@qsdfghjklm.com"
        let user = AKTestAuthenticator.User.exemple
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.waitingSeconds = 0
        
        let sut = await AuthManager(authenticator: authenticator)
        sut.emailEntry = newEmail
        sut.passwordEntry = "@Azertyuiop3"
        await sut.changeEmail()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertEqual(newEmail, sut.user?.email)
    }
    
    @MainActor func test_authentication_manager_change_email_user_not_signed_in() async throws {
        
        let newEmail = ""
        let authenticator = AKTestAuthenticator()
        authenticator.waitingSeconds = 0
        
        let sut = await AuthManager(authenticator: authenticator)
        sut.emailEntry = newEmail
        await sut.changeEmail()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.error)
        XCTAssertNotEqual(newEmail, sut.user?.email)
    }
    
    @MainActor func test_authentication_manager_change_email_missing_email() async throws {
        
        let newEmail = ""
        let user = AKTestAuthenticator.User.exemple
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.waitingSeconds = 0
        
        let sut = await AuthManager(authenticator: authenticator)
        sut.emailEntry = newEmail
        await sut.changeEmail()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.error)
        XCTAssertNotEqual(newEmail, sut.user?.email)
    }
    
    @MainActor func test_authentication_manager_change_email_invalid_email_format() async throws {
        
        let newEmail = "@qsdfghjklm.com"
        let user = AKTestAuthenticator.User.exemple
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.waitingSeconds = 0
        
        let sut = await AuthManager(authenticator: authenticator)
        sut.emailEntry = newEmail
        await sut.changeEmail()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.error)
        XCTAssertNotEqual(newEmail, sut.user?.email)
    }
    
    
}
