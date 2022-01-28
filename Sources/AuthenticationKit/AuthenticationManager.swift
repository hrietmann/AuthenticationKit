//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import Combine
import StringKit
import SwiftUI




@MainActor
@available(iOS 14.0.0, *)
public final class AuthenticationManager<Authenticator: AKAuthenticator>: ObservableObject {
    
    // - MARK: Editable properties
    @Published public var usernameEntry = ""
    @Published public var emailEntry = ""
    @Published public var passwordEntry = ""
    @Published public var passwordEntry2 = ""
    @Published public var profileImage: CGImage? = nil
    
    // - MARK: Activity states properties
    @Published public private(set) var error: Error? = nil
    @Published public private(set) var state = AKState<Authenticator.User>.loading
    public var user: Authenticator.User? { authenticator.currentUser }
    
    
    var authenticator: Authenticator
    let errorsLocalizationFile: String?
    var cancellables: Set<AnyCancellable> = []
    
    
    public init(authenticator: Authenticator, errorsLocalizationFile: String? = nil) {
        self.authenticator = authenticator
        self.errorsLocalizationFile = errorsLocalizationFile
        setupCurrentUserListner()
        
        loadCachedUser()
    }
    
    public init(authenticator: Authenticator, errorsLocalizationFile: String? = nil) async {
        self.authenticator = authenticator
        self.errorsLocalizationFile = errorsLocalizationFile
        setupCurrentUserListner()
        
        await loadCachedUser()
    }
    
    private func setupCurrentUserListner() {
        authenticator.currentUserPublisher
            .receive(on: RunLoop.main)
            .sink { currentUser in
                guard let currentUser = currentUser else { self.state = .disconnected ; return }
                self.state = .connected(user: currentUser)
                self.usernameEntry = currentUser.username ?? ""
                self.emailEntry = currentUser.email ?? ""
            }
            .store(in: &cancellables)
    }
    
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    
    // - MARK: loadCachedUser
    private func loadCachedUser() { run(loadCachedUserWork) }
    private func loadCachedUser() async { await run(loadCachedUserWork) }
    private func loadCachedUserWork() async throws {
        let cachedUser = try await self.authenticator.cachedUser
        self.authenticator.currentUser = cachedUser
    }
    
    
    // - MARK: Sign Up
    public func signUp() { run(signUpWork) }
    public func signUp() async { await run(signUpWork) }
    private func signUpWork() async throws {
        let connected = user != nil
        let usernameMissing = usernameEntry.isEmpty
        let emailMissing = emailEntry.isEmpty
        let passwordMissing = passwordEntry.isEmpty
        let isValidUsername = usernameEntry.isValidUsername
        let isValidEmail = emailEntry.isValidEmail
        let constraints = Authenticator.passwordConstraints
        let isValidPassword = passwordEntry.isValidPassword(with: constraints)
        let localizationFile = errorsLocalizationFile
        
        guard !connected else { throw UserAlreadySignedIn(localizationFile: localizationFile) }
        guard !usernameMissing else { throw UsernameMissing(localizationFile: localizationFile) }
        guard !emailMissing else { throw EmailMissing(localizationFile: localizationFile) }
        guard !passwordMissing else { throw PasswordMissing(localizationFile: localizationFile) }
        guard isValidUsername else { throw InvalidUsernameFormat(localizationFile: localizationFile) }
        guard isValidEmail else { throw InvalidEmailFormat(localizationFile: localizationFile) }
        guard isValidPassword else { throw InvalidPasswordFormat(localizationFile: localizationFile, constaints: constraints) }
        guard !passwordEntry2.isEmpty else { throw PasswordMissing(localizationFile: errorsLocalizationFile) }
        guard passwordEntry2.isValidPassword(with: constraints)
        else { throw InvalidPasswordFormat(localizationFile: errorsLocalizationFile, constaints: constraints) }
        guard passwordEntry == passwordEntry2 else { throw PasswordMismatch(localizationFile: errorsLocalizationFile) }
        try await authenticator.signUp(
            username: usernameEntry,
            email: emailEntry,
            password: passwordEntry)
    }
    
    
    // - MARK: Sign In
    public func signIn() { run(signInWork) }
    public func signIn() async { await run(signInWork) }
    private func signInWork() async throws {
        let connected = user != nil
        let emailMissing = emailEntry.isEmpty
        let passwordMissing = passwordEntry.isEmpty
        let isValidEmail = emailEntry.isValidEmail
        let constraints = Authenticator.passwordConstraints
        let isValidPassword = passwordEntry.isValidPassword(with: constraints)
        let localizationFile = errorsLocalizationFile
        
        guard !connected else { throw UserAlreadySignedIn(localizationFile: localizationFile) }
        guard !emailMissing else { throw EmailMissing(localizationFile: localizationFile) }
        guard !passwordMissing else { throw PasswordMissing(localizationFile: localizationFile) }
        guard isValidEmail else { throw InvalidEmailFormat(localizationFile: localizationFile) }
        guard isValidPassword else { throw InvalidPasswordFormat(localizationFile: localizationFile, constaints: constraints) }
        try await authenticator.signIn(
            email: emailEntry,
            password: passwordEntry)
    }
    
    
    // - MARK: Sign Out
    public func signOut() { run(signOutWork) }
    public func signOut() async { await run(signOutWork) }
    private func signOutWork() async throws {
        let localizationFile = errorsLocalizationFile
        guard let user = user else { throw UserNotSignedIn(localizationFile: localizationFile) }
        try await authenticator.signOut(user: user)
    }
    
    
    // - MARK: Change Email
    public func changeEmail() { run(changeEmailWork) }
    public func changeEmail() async { await run(changeEmailWork) }
    private func changeEmailWork()  async throws {
        guard !passwordEntry.isEmpty else { throw PasswordMissing(localizationFile: errorsLocalizationFile) }
        guard !emailEntry.isEmpty else { throw EmailMissing(localizationFile: errorsLocalizationFile) }
        guard emailEntry.isValidEmail else { throw InvalidEmailFormat(localizationFile: errorsLocalizationFile) }
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard user.email != emailEntry else { return }
        try await authenticator.change(email: emailEntry, with: passwordEntry, of: user)
    }
    
    
    // - MARK: Change Password
    public func changePassword() { run(changePasswordWork) }
    public func changePassword() async { await run(changePasswordWork) }
    private func changePasswordWork()  async throws {
        guard !passwordEntry.isEmpty else { throw PasswordMissing(localizationFile: errorsLocalizationFile) }
        guard !passwordEntry2.isEmpty else { throw PasswordMissing(localizationFile: errorsLocalizationFile) }
        let constraints = Authenticator.passwordConstraints
        guard passwordEntry2.isValidPassword(with: constraints)
        else { throw InvalidPasswordFormat(localizationFile: errorsLocalizationFile, constaints: constraints) }
        guard passwordEntry != passwordEntry2 else { return }
        guard !emailEntry.isEmpty else { throw EmailMissing(localizationFile: errorsLocalizationFile) }
        guard emailEntry.isValidEmail else { throw InvalidEmailFormat(localizationFile: errorsLocalizationFile) }
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard user.email != emailEntry else { return }
        try await authenticator.change(password: passwordEntry, to: passwordEntry2, with: emailEntry, of: user)
    }
    
    
    // - MARK: Send Email Verification
    public func sendEmailVerification() { run(sendEmailVerificationWork) }
    public func sendEmailVerification() async { await run(sendEmailVerificationWork) }
    private func sendEmailVerificationWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard !user.emailVerified else { throw EmailAlreadyVerified(localizationFile: errorsLocalizationFile) }
        if user.email == nil { try await changeEmailWork() }
        try await authenticator.sendEmailVerification(for: user)
    }
    
    
    // - MARK: Send Password Reset Email
    public func sendPasswordResetEmail() { run(sendPasswordResetEmailWork) }
    public func sendPasswordResetEmail() async { await run(sendPasswordResetEmailWork) }
    private func sendPasswordResetEmailWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        try await authenticator.sendPasswordResetEmail(for: user)
    }
    
    
    // - MARK: Change Username
    public func changeUsername() { run(changeUsernameWork) }
    public func changeUsername() async { await run(changeUsernameWork) }
    private func changeUsernameWork() async throws {
        guard !usernameEntry.isEmpty else { throw UsernameMissing(localizationFile: errorsLocalizationFile) }
        guard usernameEntry.isValidUsername else { throw InvalidUsernameFormat(localizationFile: errorsLocalizationFile) }
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        guard user.username != usernameEntry else { return }
        try await authenticator.change(username: usernameEntry, of: user)
    }
    
    
    // - MARK: Change Profile Image
    public func changeProfileImage() { run(changeProfileImageWork) }
    public func changeProfileImage() async { await run(changeProfileImageWork) }
    private func changeProfileImageWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        try await authenticator.change(profile: profileImage, of: user)
    }
    
    
    // - MARK: Delete User
    public func deleteUser() { run(deleteUserWork) }
    public func deleteUser() async { await run(deleteUserWork) }
    private func deleteUserWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
        try await authenticator.delete(user: user)
    }
    
    
    func run(_ work: @escaping () async throws -> ()) {
        Task { await run(work) }
    }
    func run(_ work: @escaping () async throws -> ()) async {
        error = nil
        state = .loading
        do { try await work() }
        catch {
            self.error = error
            guard let user = user
            else { state = .disconnected ; return }
            state = .connected(user: user)
        }
    }
    
}
