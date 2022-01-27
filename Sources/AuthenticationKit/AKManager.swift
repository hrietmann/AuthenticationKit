//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import Combine
import StringKit





@MainActor
@available(iOS 14.0.0, *)
public final class AKManager<Authenticator: AKAuthenticator>: ObservableObject {
    
    // - MARK: Editable properties
    @Published public var usernameEntry = ""
    @Published public var emailEntry = ""
    @Published public var passwordEntry = ""
    
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
