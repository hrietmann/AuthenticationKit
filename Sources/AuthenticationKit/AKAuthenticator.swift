//
//  File.swift
//  
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import Combine
import StringKit




@available(iOS 13.0.0, *)
public protocol AKAuthenticator {
    
    associatedtype User: AKUser
    
    static var passwordConstraints: [PasswordConstraint] { get }
    
    /// Current user
    var currentUser: User? { get set }
    
    /// Current user combine publisher
    var currentUserPublisher: Published<User?>.Publisher { get }
    
    /// Retreives the locally saved user
    var cachedUser: User? { get async throws }
    
    /// Use this method to create some kind of websocket/push notifications systems
    /// to receive real time updates on the specified user account.
    func addRemoteUpdatesLisnters(for user: User) async throws
    
    /// Use this method to remove all kind of websocket/push notifications systems
    /// to receive real time updates on the specified user account.
    func removeRemoteUpdatesListners(for user: User) async throws
    
    /// Remotely signup with the given parameters
    func signUp(username: String, email: String, password: String) async throws
    
    /// Remotely signin with the given parameters
    func signIn(email: String, password: String) async throws
    
    /// Locally and remotely signout the given user
    func signOut(user: User) async throws
    
    
}
