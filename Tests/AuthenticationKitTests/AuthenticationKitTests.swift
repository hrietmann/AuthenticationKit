import XCTest
@testable import AuthenticationKit

final class AuthenticationKitTests: XCTestCase {
    
    
    @MainActor func test_authentication_manager_successfull_sign_up() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let user = AKTestAuthenticator.User(username: "Username", email: "email@email.com")
        let authenticator = AKTestAuthenticator()
        authenticator.signUpResult = .success(user)
        authenticator.waitingSeconds = 0
        
        let sut = await AKManager(authenticator: authenticator)
        sut.usernameEntry = user.username
        sut.emailEntry = user.email
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        
        // Waiting for the authenticator publisher to propagate its new values to the main actor
        try await Task.sleep(nanoseconds: 100_000)
        
        XCTAssertNotNil(sut.user)
        XCTAssertTrue(sut.user?.username == user.username)
        XCTAssertTrue(sut.user?.email == user.email)
    }
    
    
    @MainActor func test_authentication_manager_failed_sign_up() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let error = AKError("Internal server error")
        let authenticator = AKTestAuthenticator()
        authenticator.signUpResult = .failure(error)
        authenticator.waitingSeconds = 0
        
        let sut = await AKManager(authenticator: authenticator)
        sut.usernameEntry = "Username"
        sut.emailEntry = "email@email.com"
        sut.passwordEntry = "Azertyuiop@1234567890"
        await sut.signUp()
        
        XCTAssertTrue(sut.error?.localizedDescription == error.localizedDescription)
    }
    
    
}
