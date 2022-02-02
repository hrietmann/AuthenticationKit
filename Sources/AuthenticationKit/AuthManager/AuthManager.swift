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
public final class AuthManager<Authenticator: AKAuthenticator>: ObservableObject {
    
    // MARK: - Editable properties -
    @Published public var usernameEntry = ""
    @Published public var emailEntry = ""
    @Published public var passwordEntry = ""
    @Published public var passwordEntry2 = ""
    @Published public var profileImage: UniversalImage? = nil
    
    // MARK: - Activity states properties -
    @Published public internal(set) var error: Error? = nil
    @Published public internal(set) var taskCompleted = false
    @Published public internal(set) var state = AKState<Authenticator.User>.loading
    public var user: Authenticator.User? { authenticator.currentUser }
    
    
    var authenticator: Authenticator
    let errorsLocalizationFile: String?
    var cancellables: Set<AnyCancellable> = []
    
    
    public init(authenticator: Authenticator, errorsLocalizationFile: String? = nil) {
        self.authenticator = authenticator
        self.errorsLocalizationFile = errorsLocalizationFile
        setupCurrentUserListners()
        
        loadCachedUser()
    }
    
    public init(authenticator: Authenticator, errorsLocalizationFile: String? = nil) async {
        self.authenticator = authenticator
        self.errorsLocalizationFile = errorsLocalizationFile
        setupCurrentUserListners()
        
        await loadCachedUser()
    }
    
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
}
