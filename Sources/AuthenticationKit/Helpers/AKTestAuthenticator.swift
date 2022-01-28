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
        public var id: UUID
        public var username: String?
        public var email: String?
        public var emailVerified: Bool
        public var profileImageURL: URL?
        
        public static var exemple: TestUser {
            TestUser(
                id: UUID(),
                username: "John Appleseed",
                email: "john.appleseed@authentication.com",
                emailVerified: true,
                profileImageURL: nil)
        }
    }
    public typealias User = TestUser
    
    @Published public var currentUser: TestUser?
    public var currentUserPublisher: Published<TestUser?>.Publisher { $currentUser }
    
    /// Supporsedly stored user in local cache
    public var cachedUser: User?
    
    /// Seconds to simulate loading time of the methods using network
    public var waitingSeconds: UInt64 = 1
    
    /// Result returned by signUp method
    public var signUpResult: Result<User,Error> = .success(.exemple)
    
    /// Result returned by signIn method
    public var signInResult: Result<User,Error> = .success(.exemple)
    
    /// Result returned by signIn method
    public var signOutResult: Error? = nil
    
    /// Result returned by changeEmail
    public var changeEmailError: Error? = nil
    
    /// Result returned by sendEmailVerification
    public var sendEmailVerificationError: Error? = nil
    
    /// Result returned by sendPasswordResetEmail
    public var sendPasswordResetEmailError: Error? = nil
    
    /// Result returned by changeUsername
    public var changeUsernameError: Error? = nil
    
    /// Result returned by changeProfile
    public var changeProfileError: Error? = nil
    
    /// Result returned by deleteUser
    public var deleteUserError: Error? = nil
    
    
    
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
    
    public func change(email: String, of user: User) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = changeEmailError { throw error }
        currentUser?.email = email
    }
    
    public func sendEmailVerification(for user: User) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = sendEmailVerificationError { throw error }
        #warning("sendEmailVerification not tested yet")
    }
    
    public func sendPasswordResetEmail(for user: User) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = sendPasswordResetEmailError { throw error }
        #warning("sendPasswordResetEmail not tested yet")
    }
    
    public func change(username: String, of user: User) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = changeUsernameError { throw error }
        currentUser?.username = username
        #warning("changeUsername not tested yet")
    }
    
    public func change(profile image: Data?, of user: User) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = changeProfileError { throw error }
        currentUser?.profileImageURL = image == nil ? nil : URL(fileURLWithPath: "")
        #warning("changeProfile not tested yet")
    }
    
    public func delete(user: User) async throws {
        if waitingSeconds > 0 {
            try await Task.sleep(nanoseconds: waitingSeconds * 1_000_000_000)
        }
        if let error = deleteUserError { throw error }
        currentUser = nil
        #warning("deleteUser not tested yet")
    }
    
    
    
}
