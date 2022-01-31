//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import XCTest
@testable import AuthenticationKit

final class SignOutTests: XCTestCase {
    
    
    @MainActor func test_authentication_manager_sign_out_successfull() async throws {
        
        var user = AKTestAuthenticator.User.exemple
        user.username = "Username"
        user.email = "email@email.com"
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.signOutResult = nil
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        await sut.signOut()
        
        // Waits for the background tasks to propagate the result on the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNil(sut.user)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.usernameEntry, "")
        XCTAssertEqual(sut.emailEntry, "")
        XCTAssertEqual(sut.passwordEntry, "")
        XCTAssertEqual(sut.passwordEntry2, "")
        XCTAssertTrue(sut.state.isDisconnected)
    }
    
    
    @MainActor func test_authentication_manager_sign_out_server_failed() async throws {
        
        var user = AKTestAuthenticator.User.exemple
        user.username = "Username"
        user.email = "email@email.com"
        let error = AKError("Internal server error")
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = user
        authenticator.signOutResult = error
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        await sut.signOut()
        
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.state.isConnected)
    }
    
    
    @MainActor func test_authentication_manager_sign_out_while_not_signed_in() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let authenticator = AKTestAuthenticator()
        authenticator.cachedUser = nil
        authenticator.signOutResult = nil
        authenticator.waitingSeconds = 0
        
        let sut = await AuthenticationManager(authenticator: authenticator)
        await sut.signOut()
        
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.state.isConnected)
    }
    
    
}
