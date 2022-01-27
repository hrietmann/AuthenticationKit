//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import StringKit



@available(iOS 13.0.0, *)
public final class AKTestAuthenticator: AKAuthenticator {
    
    public static var passwordConstraints = PasswordConstraint.allCases
    
    public struct TestUser: AKUser {
        public let username: String
        public let email: String
    }
    public typealias User = TestUser
    
    @Published public var currentUser: TestUser?
    public var currentUserPublisher: Published<TestUser?>.Publisher { $currentUser }
    
    /// Supporsedly stored user in local cache
    public var cachedUser: User?
    
    /// Seconds to simulate loading time of the methods using network
    public var waitingSeconds: UInt64 = 1
    
    /// Result returned by signUp method
    public var signUpResult: Result<User,Error> = .success(TestUser(username: "John Appleseed", email: "email@email.com"))
    
    /// Result returned by signIn method
    public var signInResult: Result<User,Error> = .success(TestUser(username: "John Appleseed", email: "email@email.com"))
    
    /// Result returned bu signIn method
    public var signOutResult: Error? = nil
    
    
    public init() {}
    
    
    public func addRemoteUpdatesLisnters(for user: User) async throws {
        
    }
    
    public func removeRemoteUpdatesListners(for user: User) async throws {
        
    }
    
    public func signUp(username: String, email: String, password: String) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        switch signUpResult {
        case .success(let user): currentUser = user
        case .failure(let error): throw error
        }
    }
    
    public func signIn(email: String, password: String) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        switch signInResult {
        case .success(let user): currentUser = user
        case .failure(let error): throw error
        }
    }
    
    public func signOut(user: TestUser) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = signOutResult { throw error }
        currentUser = nil
    }
    
}
